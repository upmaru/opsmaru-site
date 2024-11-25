defmodule OpsmaruWeb.BlogLiveTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  alias Opsmaru.Content

  setup [:setup_finch]

  describe "blog page" do
    test "can visit blog page", %{conn: conn} do
      use_cassette "blog_live_test", match_requests_on: [:query] do
        posts = Content.list_posts()

        alpine_post = Enum.find(posts, fn post -> post.slug == "alpine-linux" end)

        {:ok, lv, _html} = live(conn, ~p"/blog/#{alpine_post.slug}")

        assert render(lv) =~ "Alpine Linux"
      end
    end
  end
end
