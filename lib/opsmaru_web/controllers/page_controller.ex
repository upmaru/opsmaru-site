defmodule OpsmaruWeb.PageController do
  use OpsmaruWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def pricing(conn, _params) do
    query = "active: 'true' AND metadata['app']: 'instellar'"

    {:ok, %Stripe.SearchResult{data: prices}} =
      Stripe.Price.search(%{query: query}, expand: ["data.product"])

    prices =
      Enum.filter(prices, fn price ->
        price.recurring.interval == "month"
      end)
      |> Enum.sort_by(fn price -> price.unit_amount end)

    render(conn, :pricing, prices: prices)
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def terms(conn, _params) do
    render(conn, :terms)
  end
end
