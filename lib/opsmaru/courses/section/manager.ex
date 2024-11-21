defmodule Opsmaru.Courses.Section.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Courses.Section

  def list(course_id: course_id) do
    query = ~S"""
    *[_type == "courseSection" && course._ref == $course_id] | order(index asc){
      ...,
      chapter -> {
        ...,
        "episodes": *[ _type == "courseEpisode" && references(^._id) ] {
          ...,
          "content": content.asset -> url,
          author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
          video {
            asset -> {
              ...
            }
          }
        }
      }
    }
    """

    query
    |> Sanity.query(%{course_id: "#{course_id}"}, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> Enum.map(&Section.parse/1)
  end
end
