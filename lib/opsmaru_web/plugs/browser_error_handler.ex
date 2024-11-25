defmodule OpsmaruWeb.Plugs.BrowserErrorHandler do
  use OpsmaruWeb, :controller

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    redirect(conn, to: "/auth/users/log_in")
  end

  def auth_error(conn, {:invalid_token, :token_expired}, _opts) do
    conn
    |> Opsmaru.Guardian.Plug.sign_out()
    |> redirect(to: "/auth/users/log_in")
  end
end
