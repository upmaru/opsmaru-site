defmodule Opsmaru.Sanity do
  def request_opts do
    Application.get_env(:opsmaru, __MODULE__)
  end
end
