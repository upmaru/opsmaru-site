defmodule OpsmaruWeb.BlogLiveTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  alias Opsmaru.Content

  describe "blog page" do
    test "can visit blog page", %{conn: conn} do
      %{data: posts} = Content.list_posts()

      alpine_post = Enum.find(posts, fn post -> post.slug == "alpine-linux" end)

      {:ok, lv, _html} = live(conn, ~p"/blog/#{alpine_post.slug}")

      assert render(lv) =~ "Alpine Linux"
    end
  end
end
