defmodule Opsmaru.Posts.Category.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Posts.Category

  @ttl :timer.hours(1)

  @spec list(Keyword.t()) :: %{data: [%Category{}], perspective: String.t()}
  @decorate cacheable(cache: Opsmaru.Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~s"""
    *[_type == "postCategory"
      && count(*[_type == "post" && defined(slug.current) && ^._id in categories[]._ref]) > 0
    ] | order(name asc){...}
    """

    data =
      query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Category.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
