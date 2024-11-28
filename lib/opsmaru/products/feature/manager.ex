defmodule Opsmaru.Products.Feature.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Products.Feature

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "productFeature"]{
    ..., "product_id": product._ref, "feature_id": feature._ref
  }
  """

  @spec list(Keyword.t()) :: %{data: [%Feature{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    data =
      @base_query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Feature.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
