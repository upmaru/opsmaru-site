defmodule Opsmaru.Content.Product.Manager do
  import Opsmaru.Sanity

  alias Opsmaru.Content.Product

  def list(options \\ []) do
    cache? = Keyword.get(options, :cache)

    stripe_products = load_stripe_products()

    sanity_query = ~S"""
    *[_type == "product"]
    """

    Sanity.query(sanity_query, %{})
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => products}} ->
        products
        |> Enum.map(&Product.parse/1)
        |> Enum.map(fn product ->
          matched_product =
            Enum.find(stripe_products, fn stripe_product ->
              product.reference == stripe_product.name
            end)

          %{product | stripe_product: matched_product}
        end)
        |> Enum.sort_by(& &1.index, :asc)

      error ->
        error
    end
  end

  defp load_stripe_products do
    products_query = "active: 'true' AND metadata['app']: 'instellar'"

    {:ok, %Stripe.SearchResult{data: products}} =
      Stripe.Product.search(%{query: products_query})

    products
  end
end
