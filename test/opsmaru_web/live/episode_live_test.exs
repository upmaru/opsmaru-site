defmodule OpsmaruWeb.EpisodeLiveTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "episode page" do
    test "can visit episode page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/how-to/setup-aws-infrastructure/architecture-overview")

      rendered = render(lv)

      assert rendered =~ "1.1"

      assert rendered =~ "Architecture Overview"
    end
  end
end
