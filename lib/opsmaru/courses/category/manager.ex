defmodule Opsmaru.Courses.Category.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Courses.Category

  @spec list(Keyword.t()) :: %{data: [%Category{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(1)])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")
    featured = Keyword.get(options, :featured, false)

    query = ~s"""
    *[_type == "courseCategory" && featured == $featured] | order(index asc){
      ...,
      "courses": *[ _type == "course" && references(^._id) ] {
        ...,
        author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
        "cover": {"url": cover.asset -> url, "alt": cover.alt},
        main_technology -> {
          ...,
          category -> {...},
          "logo": { "url": logo.asset -> url, "alt": logo.alt }
        },
        "overview": overview.asset -> url,
        introduction {
          asset -> {
            ...
          }
        }
      }
    }
    """

    data =
      query
      |> Sanity.query(%{featured: featured}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Category.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
