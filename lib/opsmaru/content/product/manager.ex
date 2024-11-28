defmodule Opsmaru.Content.Product.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Product

  @ttl :timer.hours(1)

  @spec list(Keyword.t()) :: %{data: [%Product{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    stripe_products = load_stripe_products()

    sanity_query = ~S"""
    *[_type == "product"] | order(index asc)
    """

    data =
      sanity_query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Product.parse/1)
      |> Enum.map(fn product ->
        matched_product =
          Enum.find(stripe_products, fn stripe_product ->
            product.reference == stripe_product.name
          end)

        %{product | stripe_product: matched_product}
      end)

    %Response{data: data, perspective: perspective}
  end

  defp load_stripe_products do
    products_query = "active: 'true' AND metadata['app']: 'instellar'"

    {:ok, %Stripe.SearchResult{data: products}} =
      Stripe.Product.search(%{query: products_query})

    products
  end
end
