defmodule Opsmaru.Content.Post.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Post

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "post"]{
    ...,
    "cover": cover.asset -> url,
    "content": content.asset -> url
  }
  """

  @decorate cacheable(cache: Cache, key: :posts, opts: [ttl: @ttl])
  def list(_options \\ []) do
    %Sanity.Response{body: %{"result" => posts}} =
      @base_query
      |> Sanity.query(%{}, perspective: "published")
      |> Sanity.request!(request_opts())

    Enum.map(posts, fn post_params ->
      Post.parse(post_params)
    end)
  end

  def featured(_options \\ []) do
    query =
      ~S"""
      *[_type == "post" && featured == $featured][0..3] | order(_createdAt desc) {
        ...,
        "cover": cover.asset -> url,
        "content": content.asset -> url
      }
      """

    %Sanity.Response{body: %{"result" => posts}} =
      query
      |> Sanity.query(%{"featured" => true}, perspective: "published")
      |> Sanity.request!(request_opts())

    Enum.map(posts, fn post_params ->
      Post.parse(post_params)
    end)
  end

  @decorate cacheable(cache: Cache, key: {:posts, slug}, opts: [ttl: @ttl])
  def show(slug) do
    @base_query
    |> Sanity.query(%{"slug" => slug}, perspective: "published")
    |> Sanity.request!(request_opts())
    |> case do
      %Sanity.Response{body: %{"result" => [post_params]}} ->
        post = Post.parse(post_params)

        full_content = Req.get!(post.content).body

        %{post | content: full_content}

      error ->
        error
    end
  end
end
