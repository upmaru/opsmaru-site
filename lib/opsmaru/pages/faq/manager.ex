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

  def list(%Page{slug: page_slug} = page) do
    @base_query
    |> Sanity.query(%{"page.slug.current" => page_slug}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> IO.inspect()
    |> case do
      %Sanity.Response{body: %{"result" => faqs}} ->
        Enum.map(faqs, &FAQ.parse/1)
        |> Enum.sort_by(& &1.index, :asc)

      error ->
        error
    end
  end
end
