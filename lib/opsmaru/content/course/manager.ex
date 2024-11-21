defmodule Opsmaru.Content.Course.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Course

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:course, slug}, opts: [ttl: @ttl])
  def show(slug) do
    query = ~S"""
    *[_type == "course" && slug.current == $slug][0] {
      ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      "overview": overview.asset -> url,
      "cover": {"url": cover.asset -> url, "alt": cover.alt},
      main_technology -> {
        ...,
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
      |> Sanity.query(%{slug: slug}, perspective: "published")
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()

    course = Course.parse(course)
    full_overview = Req.get!(course.overview).body
    %{course | overview: full_overview}
  end
end
