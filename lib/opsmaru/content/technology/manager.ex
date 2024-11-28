defmodule Opsmaru.Content.Technology.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Technology

  @ttl :timer.hours(1)

  @spec list(Keyword.t()) :: %{data: [%Technology{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")
    end_index = Keyword.get(options, :end_index, 5)

    query = ~S"""
      *[_type == "technology"][0..$end_index] {
        ...,
        category -> {...},
        "logo": {"url": logo.asset -> url, "alt": logo.alt}
      }
    """

    data =
      query
      |> Sanity.query(%{end_index: end_index}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Technology.parse/1)

    %{data: data, perspective: perspective}
  end
end
