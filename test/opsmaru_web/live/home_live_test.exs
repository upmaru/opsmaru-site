defmodule OpsmaruWeb.HomeLiveTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "home when not logged in" do
    test "can visit home page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/")

      rendered = render(lv)

      assert rendered =~ "Deploy"
      assert rendered =~ "Monetize"

      assert rendered =~ "Cloud provider" || rendered =~ "Web framework"
    end
  end
end
