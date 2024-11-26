defmodule OpsmaruWeb.PricingLiveTest do
  use OpsmaruWeb.ConnCase, async: true

  import Phoenix.LiveViewTest

  setup do
    bypass = Bypass.open()

    Application.put_env(:stripity_stripe, :api_base_url, "http://localhost:#{bypass.port}")

    {:ok, bypass: bypass}
  end

  describe "pricing page" do
    setup do
      price_search_response = File.read!("test/fixture/stripe/prices.json")
      product_search_response = File.read!("test/fixture/stripe/products.json")

      {:ok,
       price_search_response: price_search_response,
       product_search_response: product_search_response}
    end

    test "can visit pricing page", %{
      conn: conn,
      bypass: bypass,
      price_search_response: price_search_response,
      product_search_response: product_search_response
    } do
      Bypass.expect_once(bypass, "GET", "/v1/prices/search", fn conn ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, price_search_response)
      end)

      Bypass.expect_once(bypass, "GET", "/v1/products/search", fn conn ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, product_search_response)
      end)

      {:ok, lv, _html} = live(conn, ~p"/our-product/pricing")

      rendered = render(lv)

      assert rendered =~ "Launch with a plan that makes"

      assert rendered =~ "generous"
    end
  end
end
