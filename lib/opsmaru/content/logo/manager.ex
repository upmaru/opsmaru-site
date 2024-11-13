defmodule Opsmaru.Content.Logo.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Logo

  @decorate cacheable(cache: Cache, key: :logos, opts: [ttl: :timer.hours(1)])
  def list(_options \\ []) do
    query = ~s"""
    *[_type == "logo"] | order(name asc){..., "image": image.asset -> url}
    """

    %Sanity.Response{body: %{"result" => logos}} =
      query
      |> Sanity.query(%{}, perspective: "published")
      |> Sanity.request!(sanity_request_opts())

    Enum.map(logos, &Logo.parse/1)
  end
end
