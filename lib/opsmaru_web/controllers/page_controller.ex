defmodule OpsmaruWeb.PageController do
  use OpsmaruWeb, :controller

  def privacy(conn, _params) do
    render(conn, :privacy)
  end

  def terms(conn, _params) do
    render(conn, :terms)
  end
end
