defmodule OpsmaruWeb.PostController do
  use OpsmaruWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
