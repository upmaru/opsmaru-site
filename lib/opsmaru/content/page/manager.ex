defmodule Opsmaru.Content.Page.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Page

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, key: {:pages, slug}, opts: [ttl: @ttl])
  def show(slug) do
    %Sanity.Response{body: %{"result" => page_params}} =
      ~S"""
      *[_type == "page" && slug.current == $slug][0]{
        ...,
        "sections": *[ _type == "pageSection" && references(^._id) ]{
          ...,
          "contents": *[ _type == "pageContent" && references(^._id) ]{
            ...
          }
        }
      }
      """
      |> Sanity.query(%{"slug" => slug}, perspective: "published")
      |> Sanity.request!(request_opts())

    Page.parse(page_params)
  end
end
