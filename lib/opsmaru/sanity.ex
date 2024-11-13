defmodule Opsmaru.Sanity do
  def sanity_request_opts do
    Application.get_env(:opsmaru, __MODULE__)
  end
end
