defmodule OpsmaruWeb.PageController do
  use OpsmaruWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def pricing(conn, _params) do
    render(conn, :pricing)
  end
end
