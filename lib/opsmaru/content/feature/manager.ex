defmodule Opsmaru.Content.Feature.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Content.Feature

  def list(options \\ [cache: true]) do
    cache? = Keyword.get(options, :cache)

    query = ~S"""
    *[_type == "productFeature"]{
      ..., product -> {...}, feature -> {..., category -> {...}}
    }
    """

    Sanity.query(query, %{}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => features}} ->
        Enum.map(features, &Feature.parse/1)

      error ->
        error
    end
  end
end
