defmodule OpsmaruWeb.BlogLive.IndexTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  setup [:setup_finch]

  describe "blog listing" do
    test "can visit blog listing", %{conn: conn} do
      use_cassette "blog_live_index_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/blog")

        assert render(lv) =~ "What&#39;s happening at Opsmaru"
      end
    end

    test "can filter blog by category", %{conn: conn} do
      use_cassette "blog_live_index_category_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/blog?category=engineering")

        rendered = render(lv)

        assert rendered =~ "Engineering"

        refute rendered =~ "Featured"
      end
    end

    test "can filter by page", %{conn: conn} do
      use_cassette "blog_live_index_page_test", match_requests_on: [:query] do

        {:ok, lv, _html} = live(conn, ~p"/blog?page=2")

        rendered = render(lv)

        assert rendered =~ "PAKman"
      end
    end
  end
end
