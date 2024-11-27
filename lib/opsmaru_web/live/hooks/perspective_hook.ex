defmodule OpsmaruWeb.PerspectiveHook do
  import Phoenix.Component
  import Phoenix.LiveView

  def on_mount(:default, _params, _session, socket) do
    case get_connect_info(socket, :uri) do
      %URI{host: host} ->
        socket =
          if host =~ "preview" do
            assign(socket, :perspective, "raw")
          else
            assign(socket, :perspective, "published")
          end

        {:cont, socket}

      nil ->
        {:cont, assign(socket, :perspective, "published")}
    end
  end
end
