defmodule Opsmaru.Content.Page.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "page"]{
    ...,
    "sections": *[ _type == "pageSection" && references(^._id) ]{
      ...,
      "contents": *[ _type == "pageContent" && references(^._id) ]{
        ...
      }
    }
  }
  """

  @decorate cacheable(cache: Cache, key: {:pages, slug}, opts: [ttl: @ttl])
  def show(slug) do
    @base_query
    |> Sanity.query(%{"slug" => slug}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => [page_params]}} ->
        Page.parse(page_params)

      other ->
        other
    end
  end
end
