defmodule OpsmaruWeb.PricingLive.DataLoader do
  alias Opsmaru.Content

  def load_prices(interval \\ "month") do
    Content.list_prices()
    |> Enum.filter(fn price ->
      price.recurring.interval == interval
    end)
    |> Enum.sort_by(fn price -> price.unit_amount end)
  end
end
