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

  @decorate cacheable(cache: Cache, key: :feature_categories, opts: [ttl: @ttl])
  def list(_options \\ []) do
    @base_query
    |> Sanity.query(%{}, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => categories}} ->
        Enum.map(categories, &Category.parse/1)
        |> Enum.sort_by(& &1.index, :asc)

      error ->
        error
    end
  end
end
