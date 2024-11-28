defmodule Opsmaru.Content.Price.Manager do
  use Nebulex.Caching

  alias Opsmaru.Cache

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, opts: [ttl: @ttl])
  def list do
    query = "active: 'true' AND metadata['app']: 'instellar'"

    {:ok, %Stripe.SearchResult{data: prices}} =
      Stripe.Price.search(%{query: query}, expand: ["data.product"])

    prices
  end
end
