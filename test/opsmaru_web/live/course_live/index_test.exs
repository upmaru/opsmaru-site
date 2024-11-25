defmodule OpsmaruWeb.CourseLive.IndexTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  setup [:setup_finch]

  describe "learn page" do
    test "can visit learn page", %{conn: conn} do
      use_cassette "course_live_index_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/how-to")

        assert render(lv) =~ "Learn and earn"
      end
    end
  end
end
