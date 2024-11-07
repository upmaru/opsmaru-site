defmodule OpsmaruWeb.PageController do
  use OpsmaruWeb, :controller

  alias Opsmaru.Content
  alias Opsmaru.Features

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def pricing(conn, _params) do
    prices_query = "active: 'true' AND metadata['app']: 'instellar'"

    {:ok, %Stripe.SearchResult{data: prices}} =
      Stripe.Price.search(%{query: prices_query}, expand: ["data.product"])

    prices =
      Enum.filter(prices, fn price ->
        price.recurring.interval == "month"
      end)
      |> Enum.sort_by(fn price -> price.unit_amount end)

    products = Content.list_products()
    categories = Features.list_categories()

    render(conn, :pricing, prices: prices, products: products, categories: categories)
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def terms(conn, _params) do
    render(conn, :terms)
  end
end
