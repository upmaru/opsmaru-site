defmodule Opsmaru.Content.Technology.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Technology

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:technologies, options}, opts: [ttl: @ttl])
  def list(options \\ []) do
    options = Enum.into(options, %{})

    query = ~S"""
      *[_type == "technology"] {
        ...,
        "logo": {"url": logo.asset -> url, "alt": logo.alt}
      }
    """

    query
    |> Sanity.query(options, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> Enum.map(&Technology.parse/1)
  end
end
