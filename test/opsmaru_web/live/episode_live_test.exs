defmodule OpsmaruWeb.EpisodeLiveTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  setup [:setup_finch]

  describe "episode page" do
    test "can visit episode page", %{conn: conn} do
      use_cassette "episode_live_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/how-to/setup-aws-infrastructure/architecture-overview")

        rendered = render(lv)

        assert rendered =~ "1.1"

        assert rendered =~ "Architecture Overview"
      end
    end
  end
end
