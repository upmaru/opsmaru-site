defmodule OpsmaruWeb.LevalLiveTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "legal page" do
    test "can visit privacy policy", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/legal/privacy-policy")

      assert render(lv) =~ "Privacy Policy"
    end

    test "can visit terms of use", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/legal/terms-of-use")

      assert render(lv) =~ "Terms of Use"
    end
  end
end
