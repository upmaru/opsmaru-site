defmodule Opsmaru.Cache do
  use Nebulex.Cache,
    otp_app: :opsmaru,
    adapter: Nebulex.Adapters.Replicated,
    default_key_generator: __MODULE__

  @behaviour Nebulex.Caching.KeyGenerator

  @impl true
  def generate(mod, fun, args), do: :erlang.phash2({mod, fun, args})
end
