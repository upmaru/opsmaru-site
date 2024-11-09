defmodule Opsmaru.Pages.FAQ.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page
  alias Opsmaru.Pages.FAQ

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "pageFaq"]{..., faq -> {question, answer}}
  """

  @decorate cacheable(cache: Cache, key: {:faqs, page_slug}, opts: [ttl: @ttl])
  def list(%Page{slug: page_slug}) do
    %Sanity.Response{body: %{"result" => faqs}} =
      @base_query
      |> Sanity.query(%{"page.slug.current" => page_slug}, perspective: "published")
      |> Sanity.request!(request_opts())

    faqs
    |> Enum.map(&FAQ.parse/1)
    |> Enum.sort_by(& &1.index, :asc)
  end
end
