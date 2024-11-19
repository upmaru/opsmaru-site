defmodule Opsmaru.Content.Slide.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Slide

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:slides, options}, opts: [ttl: @ttl])
  def list(options \\ []) do
    options = Enum.into(options, %{})

    query =
      ~S"""
      *[_type == "slide"] | order(index asc) {
        ...,
        "image": {"url": image.asset -> url, "alt": image.alt}
      }
      """

    %Sanity.Response{body: %{"result" => slides}} =
      query
      |> Sanity.query(options, perspective: "published")
      |> Sanity.request!(sanity_request_opts())

    Enum.map(slides, &Slide.parse/1)
  end
end
