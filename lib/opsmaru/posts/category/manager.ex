defmodule Opsmaru.Posts.Category.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Posts.Category

  def list(_options \\ []) do
    query = ~s"""
    *[_type == "postCategory"
      && count(*[_type == "post" && defined(slug.current) && ^._id in categories[]._ref]) > 0
    ] | order(name asc){...}
    """

    %Sanity.Response{body: %{"result" => categories}} =
      query
      |> Sanity.query(%{}, perspective: "published")
      |> Sanity.request!(sanity_request_opts())

    Enum.map(categories, &Category.parse/1)
  end
end
