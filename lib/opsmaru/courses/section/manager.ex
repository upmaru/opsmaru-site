defmodule Opsmaru.Courses.Section.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Courses.Section

  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")
    course_id = Keyword.fetch!(options, :course_id)

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

    data =
      query
      |> Sanity.query(%{course_id: "#{course_id}"}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Section.parse/1)

    %{data: data, perspective: perspective}
  end
end
