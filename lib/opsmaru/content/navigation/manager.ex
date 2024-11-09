defmodule Opsmaru.Content.Navigation.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Content.Navigation

  @ttl :timer.hours(24)

  @base_query ~S"""
  *[_type == "navigation"]{
    ...,
    "links": *[ _type == "link" && references(^._id) ]{
      ...
    }
  }
  """

  @decorate cacheable(cache: Opsmaru.Cache, key: :navigations, opts: [ttl: @ttl])
  def list(_options \\ []) do
    @base_query
    |> Sanity.query(%{}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => navigations}} ->
        Enum.map(navigations, &Navigation.parse/1)

      error ->
        error
    end
  end
end
