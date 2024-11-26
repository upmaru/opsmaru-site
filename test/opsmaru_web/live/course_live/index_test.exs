defmodule OpsmaruWeb.CourseLive.IndexTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "learn page" do
    test "can visit learn page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/how-to")

      assert render(lv) =~ "Learn and earn"
    end
  end
end
