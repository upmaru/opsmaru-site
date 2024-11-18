defmodule Opsmaru.Content.Testimonial.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Testimonial

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:testimonials, options}, opts: [ttl: @ttl])
  def list(options \\ []) do
    options = Enum.into(options, %{})

    query = ~S"""
      *[_type == "testimonial"] {
        ...,
        "cover": {"url": cover.asset -> url, "alt": cover.alt}
      }
    """

    query
    |> Sanity.query(options, perspective: "published")
    |> Sanity.request!(sanity_request_opts())
    |> Sanity.result!()
    |> Enum.map(&Testimonial.parse/1)
  end
end
