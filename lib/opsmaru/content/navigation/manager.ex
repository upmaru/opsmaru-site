defmodule Opsmaru.Content.Navigation.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Content.Navigation

  @ttl :timer.hours(24)

  @base_query ~S"""
  *[_type == "navigation"]{
    ...,
    "links": *[ _type == "link" && references(^._id) ] | order(index asc) {
      ...
    }
  }
  """

  @spec list(Keyword.t()) :: %{data: [%Navigation{}], perspective: String.t()}
  @decorate cacheable(cache: Opsmaru.Cache, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    data =
      @base_query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Navigation.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
