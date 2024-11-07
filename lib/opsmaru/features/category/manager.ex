defmodule Opsmaru.Features.Category.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Features.Category

  def list(options \\ [cache: true]) do
    cache? = Keyword.get(options, :cache)

    query = ~S"""
    *[_type == "featureCategory"]{..., "features": *[ _type == "feature" && references(^._id) ]{...}}
    """

    Sanity.query(query, %{}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => categories}} ->
        Enum.map(categories, &Category.parse/1)
        |> Enum.sort_by(& &1.index, :asc)

      error ->
        error
    end
  end
end
