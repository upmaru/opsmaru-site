defmodule Opsmaru.Content.Testimonial.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

  alias Opsmaru.Cache
  alias Opsmaru.Content.Testimonial

  @ttl :timer.hours(1)

  @spec list(Keyword.t()) :: %{data: [%Testimonial{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~S"""
      *[_type == "testimonial"] {
        ...,
        "cover": {"url": cover.asset -> url, "alt": cover.alt}
      }
    """

    data =
      query
      |> Sanity.query(options, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Testimonial.parse/1)

    %Response{data: data, perspective: perspective}
  end
end
