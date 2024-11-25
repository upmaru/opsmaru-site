defmodule OpsmaruWeb.UserHook do
  import Phoenix.Component

  def on_mount(:current_user, _params, session, socket) do
    socket = mount_current_user(session, socket)

    {:cont, socket}
  end

  defp mount_current_user(session, socket) do
    with %{"guardian_default_token" => token} <- session,
         {:ok, user, _claims} <- Opsmaru.Guardian.resource_from_token(token) do
      socket
      |> assign_new(:current_user, fn -> user end)
      |> assign_new(:current_user_id, fn -> user.id end)
    else
      _ ->
        socket
        |> assign_new(:current_user, fn -> nil end)
        |> assign_new(:current_user_id, fn -> nil end)
    end
  end
end
