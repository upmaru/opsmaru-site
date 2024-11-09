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
