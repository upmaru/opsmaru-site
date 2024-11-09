defmodule OpsmaruWeb.HomeLive.DataLoader do
  alias Opsmaru.Content

  def load_navigation do
    Content.list_nagivations()
    |> Enum.find(fn navigation ->
      navigation.slug == "main"
    end)
  end
end
