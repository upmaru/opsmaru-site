defmodule Opsmaru.Content.Slide.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Slide

  @ttl :timer.hours(1)

  @spec list(Keyword.t()) :: %{data: [%Slide{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query =
      ~S"""
      *[_type == "slide"] | order(index asc) {
        ...,
        "image": {"url": image.asset -> url, "alt": image.alt}
      }
      """

    data =
      query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Slide.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
