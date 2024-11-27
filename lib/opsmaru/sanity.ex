defmodule Opsmaru.Sanity do
  def sanity_request_opts do
    Application.get_env(:opsmaru, __MODULE__)
  end

  def sanity_cache?(%{perspective: "raw"}), do: false

  def sanity_cache?(%{perspective: "published", data: []}), do: false
  def sanity_cache?(%{perspective: "published"}), do: true
end
