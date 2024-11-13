defmodule Opsmaru.Content.Movie.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Movie

  @spec show(String.t()) :: %Movie{}
  @decorate cacheable(cache: Cache, key: {:movie, slug}, opts: [ttl: :timer.hours(1)])
  def show(slug) do
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

    %Sanity.Response{body: %{"result" => movie_params}} =
      query
      |> Sanity.query(%{slug: slug}, perspective: "published")
      |> Sanity.request!(sanity_request_opts())

    Movie.parse(movie_params)
  end
end
