defmodule OpsmaruWeb.PerspectiveHook do
  import Phoenix.Component

  def on_mount(:default, _params, _session, %{host_uri: uri} = socket) do
    socket =
      assign_new(socket, :perspective, fn ->
        if uri.host =~ "preview" do
          "raw"
        else
          "published"
        end
      end)

    {:cont, socket}
  end
end
