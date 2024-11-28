defmodule Opsmaru.Courses.Episode.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Courses.Episode

  @spec show(String.t(), String.t(), Keyword.t()) :: %{data: %Episode{}, perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(1)])
  def show(course_slug, episode_slug, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~S"""
    *[_type == "courseEpisode"
      && slug.current == $episode_slug
      && chapter -> course -> slug.current == $course_slug][0] {
      ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      "content": content.asset -> url,
      "section": *[_type == "courseSection" && course -> slug.current == $course_slug && chapter._ref == ^.chapter._ref][0] { ..., chapter -> {...} },
      video {
        asset -> {
          ...
        }
      }
    }
    """

    episode =
      query
      |> Sanity.query(%{course_slug: course_slug, episode_slug: episode_slug},
        perspective: perspective
      )
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Episode.parse()

    full_content = Req.get!(episode.content).body

    %{data: %{episode | content: full_content}, perspective: perspective}
  end
end
