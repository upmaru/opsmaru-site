defmodule Opsmaru.Robot do
  def enable_indexing? do
    config(:indexing)
  end

  defp config(key) do
    Application.get_env(:opsmaru, Opsmaru.Robot)
    |> Keyword.get(key)
  end
end
