defmodule Opsmaru.Content.Logo.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Logo

  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(1)])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~s"""
    *[_type == "logo"] | order(name asc){..., "image": image.asset -> url}
    """

    data =
      query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Logo.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
