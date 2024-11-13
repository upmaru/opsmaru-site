defmodule OpsmaruWeb.Blog.RssController do
  use OpsmaruWeb, :controller

  alias Opsmaru.Content

  plug :put_layout, false

  def index(conn, _params) do
    posts = Content.posts_feed()

    conn
    |> put_resp_content_type("application/rss+xml")
    |> render("index.xml", posts: posts)
  end
end
