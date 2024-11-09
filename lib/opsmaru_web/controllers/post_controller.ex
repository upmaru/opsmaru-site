defmodule OpsmaruWeb.PostController do
  use OpsmaruWeb, :controller

  alias Opsmaru.Content

  def index(conn, _params) do
    navigations = Content.list_nagivations()
    posts = Content.list_posts()

    render(conn, :index, navigations: navigations, posts: posts)
  end
end
