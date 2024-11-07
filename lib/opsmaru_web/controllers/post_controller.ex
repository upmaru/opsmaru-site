defmodule OpsmaruWeb.PostController do
  use OpsmaruWeb, :controller

  alias Opsmaru.Content

  def index(conn, _params) do
    posts = Content.list_posts()

    render(conn, :index, posts: posts)
  end
end
