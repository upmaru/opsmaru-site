defmodule OpsmaruWeb.PerspectiveHook do
  import Phoenix.Component
  import Phoenix.LiveView

  alias Opsmaru.Cache

  def on_mount(:default, _params, _session, socket) do
    case get_connect_info(socket, :uri) do
      %URI{host: host} ->
        socket =
          if host =~ "preview" do
            Cache.flush()

            assign_new(socket, :perspective, fn -> "raw" end)
          else
            assign_new(socket, :perspective, fn -> "published" end)
          end

        {:cont, socket}

      nil ->
        {:cont, assign(socket, :perspective, fn -> "published" end)}
    end
  end
end
