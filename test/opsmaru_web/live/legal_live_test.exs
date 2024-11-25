defmodule OpsmaruWeb.LevalLiveTest do
  use OpsmaruWeb.ConnCase, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  import Opsmaru.Scenarios
  import Phoenix.LiveViewTest

  setup [:setup_finch]

  describe "legal page" do
    test "can visit privacy policy", %{conn: conn} do
      use_cassette "privacy_policy_live_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/legal/privacy-policy")

        assert render(lv) =~ "Privacy Policy"
      end
    end

    test "can visit terms of use", %{conn: conn} do
      use_cassette "terms_of_use_live_test", match_requests_on: [:query] do
        {:ok, lv, _html} = live(conn, ~p"/legal/terms-of-use")

        assert render(lv) =~ "Terms of Use"
      end
    end
  end
end
