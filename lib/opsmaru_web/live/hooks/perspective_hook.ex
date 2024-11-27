defmodule OpsmaruWeb.PerspectiveHook do
  import Phoenix.Component

  alias Opsmaru.Cache

  def on_mount(:default, _params, _session, %{host_uri: uri} socket) do
    socket =
      assign_new(socket, :perspective, fn ->
        if uri.host =~ "preview" do
          Cache.flush()

          "raw"
        else
          "published"
        end
      end)

    {:cont, socket}
  end
end
