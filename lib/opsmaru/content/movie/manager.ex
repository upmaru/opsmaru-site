defmodule Opsmaru.Content.Movie.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Movie

  @spec show(String.t()) :: %Movie{}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(1)])
  def show(slug, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~S"""
    *[_type == "movie" && slug.current == $slug][0]{
      ...,
      video {
        asset -> {
          ...
        }
      }
    }
    """

    data =
      query
      |> Sanity.query(%{slug: slug}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Movie.parse()

    %{data: data, perspective: perspective}
  end
end
