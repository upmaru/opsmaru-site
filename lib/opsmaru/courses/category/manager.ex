defmodule Opsmaru.Courses.Category.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Courses.Category

  def list(_options \\ []) do
    query = ~s"""
    *[_type == "courseCategory"] | order(index asc){
      ...,
      "courses": *[ _type == "course" && references(^._id) ] {
        ...,
        main_technology -> {
          ...,
          "logo": { "url": logo.asset -> url, "alt": logo.alt }
        }
      }
    }
    """

    query
    |> Sanity.query(%{}, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> Enum.map(&Category.parse/1)
  end
end
