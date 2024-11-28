defmodule Opsmaru.Content.Course.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Course

  @ttl :timer.hours(1)

  @spec show(String.t(), Keyword.t()) :: %{data: %Course{}, perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def show(slug, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~S"""
    *[_type == "course" && slug.current == $slug][0] {
      ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      "overview": overview.asset -> url,
      "cover": {"url": cover.asset -> url, "alt": cover.alt},
      main_technology -> {
        ...,
        category -> {...},
        "logo": { "url": logo.asset -> url, "alt": logo.alt }
      },
      introduction {
        asset -> {
          ...
        }
      }
    }
    """

    course =
      query
      |> Sanity.query(%{slug: slug}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()

    course = Course.parse(course)
    full_overview = Req.get!(course.overview).body

    %Response{data: %{course | overview: full_overview}, perspective: perspective}
  end
end
