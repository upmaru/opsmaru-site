defmodule Opsmaru.Products.Feature.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Products.Feature

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "productFeature"]{
    ..., "product_id": product._ref, "feature_id": feature._ref
  }
  """

  @decorate cacheable(cache: Cache, key: :product_features, opts: [ttl: @ttl])
  def list(_options \\ []) do
    @base_query
    |> Sanity.query(%{}, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => features}} ->
        Enum.map(features, &Feature.parse/1)

      error ->
        error
    end
  end
end
