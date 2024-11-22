defmodule Opsmaru.Courses.Category.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Courses.Category

  def list(options \\ [featured: false]) do
    options = Enum.into(options, %{})

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

    query
    |> Sanity.query(options, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> Enum.map(&Category.parse/1)
  end
end
