defmodule OpsmaruWeb.Robot do
  def enable_indexing?(conn) do
    not String.contains?(conn.host, "preview") && config(:indexing)
  end

  defp config(key) do
    Application.get_env(:opsmaru, Opsmaru.Robot)
    |> Keyword.get(key)
  end
end
