defmodule OpsmaruWeb.PageController do
  use OpsmaruWeb, :controller

  alias Opsmaru.Content
  alias Opsmaru.Features
  alias Opsmaru.Products
  alias Opsmaru.Pages

  def home(conn, _params) do
    navigations = Content.list_nagivations()
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false, nagivations: navigations)
  end

  def pricing(conn, _params) do
    navigations = Content.list_nagivations()

    prices =
      Content.list_prices()
      |> Enum.filter(fn price ->
        price.recurring.interval == "month"
      end)
      |> Enum.sort_by(fn price -> price.unit_amount end)

    page = Content.show_page("pricing")
    faqs = Pages.list_faqs(page)

    products = Content.list_products()
    categories = Features.list_categories()
    product_features = Products.list_features()

    render(conn, :pricing,
      navigations: navigations,
      page_title: page.title,
      page: page,
      faqs: faqs,
      prices: prices,
      products: products,
      categories: categories,
      product_features: product_features
    )
  end

  def product(conn, _params) do
    navigations = Content.list_nagivations()

    render(conn, :product, navigations: navigations)
  end

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def terms(conn, _params) do
    render(conn, :terms)
  end
end
