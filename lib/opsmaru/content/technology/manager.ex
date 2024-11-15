defmodule Opsmaru.Content.Technology.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Technology

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:technologies, options}, opts: [ttl: @ttl])
  def list(options \\ []) do
    query = ~S"""
      *[_type == "technology"] {
        ...,
        "logo": {"url": logo.asset -> url, "alt": logo.alt}
      }
    """

    %Sanity.Response{body: %{"result" => technologies}} =
      query
      |> Sanity.query(%{}, perspective: "published")
      |> Sanity.request!(sanity_request_opts())

    Enum.map(technologies, &Technology.parse/1)
  end
end
