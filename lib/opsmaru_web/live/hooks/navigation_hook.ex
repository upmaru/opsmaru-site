defmodule OpsmaruWeb.NavigationHook do
  import Phoenix.Component
  import Phoenix.LiveView

  alias Opsmaru.Content

  def on_mount(:main, _params, _session, %{assigns: assigns} = socket) do
    %{data: navigations} = Content.list_navigations(perspective: assigns.perspective)

    navigation = Enum.find(navigations, &(&1.slug == "main"))

    socket =
      assign_new(socket, :main_nav, fn -> navigation end)
      |> assign(:mobile_nav_active, false)

    socket = attach_hook(socket, :toggle, :handle_event, &handle_event/3)

    {:cont, socket}
  end

  def handle_event("toggle", %{"component" => "mobile-nav"}, %{assigns: assigns} = socket) do
    {:halt, assign(socket, :mobile_nav_active, not assigns.mobile_nav_active)}
  end

  def handle_event(_, _params, socket) do
    {:cont, socket}
  end
end
