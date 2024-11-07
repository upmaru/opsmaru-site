defmodule Opsmaru.Cache do
  use Nebulex.Cache,
    otp_app: :opsmaru,
    adapter: Nebulex.Adapters.Replicated
end
