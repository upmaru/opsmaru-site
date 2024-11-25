defmodule OpsmaruWeb.HomeLiveTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  setup [:setup_finch]

  describe "home when not logged in" do
    test "can visit home page", %{conn: conn} do
      use_cassette "home_live_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/")

        assert render(lv) =~ "Deploy &amp; Monetize"
      end
    end
  end
end
