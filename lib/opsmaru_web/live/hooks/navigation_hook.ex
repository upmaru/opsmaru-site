defmodule OpsmaruWeb.NavigationHook do
  import Phoenix.Component

  alias Opsmaru.Content

  def on_mount(:main, _params, _session, socket) do
    navigation =
      Content.list_nagivations()
      |> Enum.find(&(&1.slug == "main"))

    socket = assign_new(socket, :main_nav, fn -> navigation end)

    {:cont, socket}
  end
end
