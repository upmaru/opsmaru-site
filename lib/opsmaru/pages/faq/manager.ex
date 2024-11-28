defmodule Opsmaru.Pages.FAQ.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page
  alias Opsmaru.Pages.FAQ

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "pageFaq" && page -> slug.current == $page_slug] | order(index asc) {..., faq -> {question, answer}}
  """

  @spec list(%Page{}, Keyword.t()) :: %{data: [%FAQ{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(%Page{slug: page_slug}, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    data =
      @base_query
      |> Sanity.query(%{page_slug: page_slug}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&FAQ.parse/1)

    %{data: data, perspective: perspective}
  end
end
