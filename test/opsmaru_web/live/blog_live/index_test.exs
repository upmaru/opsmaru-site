defmodule OpsmaruWeb.BlogLive.IndexTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  describe "blog listing" do
    test "can visit blog listing", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/blog")

      assert render(lv) =~ "What&#39;s happening at Opsmaru"
    end

    test "can filter blog by category", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/blog?category=engineering")

      rendered = render(lv)

      assert rendered =~ "Engineering"

      refute rendered =~ "Featured"
    end

    test "can filter by page", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/blog?page=2")

      rendered = render(lv)

      assert rendered =~ "PAKman"
    end
  end
end
