defmodule Opsmaru.Content.Post.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Post

  @ttl :timer.hours(1)

  @base_query ~S"""
  *[_type == "post"] | order(published_at desc){
    ...,
    author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
    "cover": {"url": cover.asset -> url, "alt": cover.alt},
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

  @decorate cacheable(cache: Cache, key: {:posts, :featured, options}, opts: [ttl: @ttl])
  def featured(options \\ []) do
    limit = Keyword.get(options, :limit, 3)

    query =
      ~S"""
      *[_type == "post" && featured == $featured][0...$limit] | order(published_at desc) {
        ...,
        author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
        "cover": {"url": cover.asset -> url, "alt": cover.alt},
        "content": content.asset -> url
      }
      """

    %Sanity.Response{body: %{"result" => posts}} =
      query
      |> Sanity.query(%{"featured" => true, "limit" => limit}, perspective: "published")
      |> Sanity.request!(request_opts())

    Enum.map(posts, fn post_params ->
      Post.parse(post_params)
    end)
  end

  @decorate cacheable(cache: Cache, key: {:posts, slug}, opts: [ttl: @ttl])
  def show(slug) do
    query = ~S"""
    *[_type == "post" && slug.current == $slug][0]{
      ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      "cover": {"url": cover.asset -> url, "alt": cover.alt},
      "content": content.asset -> url
    }
    """

    %Sanity.Response{body: %{"result" => post_params}} =
      query
      |> Sanity.query(%{"slug" => slug}, perspective: "published")
      |> Sanity.request!(request_opts())

    post = Post.parse(post_params)
    full_content = Req.get!(post.content).body
    %{post | content: full_content}
  end
end
