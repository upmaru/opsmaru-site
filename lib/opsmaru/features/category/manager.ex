defmodule Opsmaru.Features.Category.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Features.Category

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "featureCategory"]{
    ...,
    "features": *[ _type == "feature" && references(^._id) ]
    {
      ...
    }
  }
  """

  @spec list(Keyword.t()) :: %{data: [%Category{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    data =
      @base_query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Category.parse/1)

    %{data: data, perspective: perspective}
  end
end
