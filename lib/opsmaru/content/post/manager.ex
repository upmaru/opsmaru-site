defmodule Opsmaru.Content.Post.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Cache
  alias Opsmaru.Content.Post

  @ttl :timer.hours(1)

  @base_query ~S"""
    *[_type == "post"
      && (featured != true || defined($category))
      && (published_at < $last_published_at || (published_at == $last_published_at && _id < $last_id))
      && select(defined($category) => $category in categories[] -> slug.current, true)
   ] | order(published_at desc) [$start_index...$end_index] {
    ...,
    author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
    categories[] -> {...},
    "cover": {"url": cover.asset -> url, "alt": cover.alt},
    "content": content.asset -> url
  }
  """

  @decorate cacheable(cache: Cache, key: {:posts, options}, opts: [ttl: @ttl])
  def list(options \\ []) do
    start_index = Keyword.get(options, :start_index, 0)
    end_index = Keyword.get(options, :end_index, 5)
    category = Keyword.get(options, :category)
    last_id = Keyword.get(options, :last_id, "")
    last_published_at = Keyword.get(options, :last_published_at, Date.utc_today())

    %Sanity.Response{body: %{"result" => posts}} =
      @base_query
      |> Sanity.query(%{
        start_index: start_index,
        end_index: end_index,
        category: category,
        last_id: last_id,
        last_published_at: last_published_at
      }, perspective: "published")
      |> Sanity.request!(request_opts())

    Enum.map(posts, fn post_params ->
      Post.parse(post_params)
    end)
  end

  @decorate cacheable(cache: Cache, key: {:featured_posts, options}, opts: [ttl: @ttl])
  def featured(options \\ []) do
    limit = Keyword.get(options, :limit, 3)

    query =
      ~S"""
      *[_type == "post" && featured == $featured] | order(published_at desc) [0...$limit] {
        ...,
        author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
        categories[] -> {...},
        "cover": {"url": cover.asset -> url, "alt": cover.alt},
        "content": content.asset -> url
      }
      """

    %Sanity.Response{body: %{"result" => posts}} =
      query
      |> Sanity.query(%{featured: true, limit: limit}, perspective: "published")
      |> Sanity.request!(request_opts())

    Enum.map(posts, fn post_params ->
      Post.parse(post_params)
    end)
  end

  @spec show(String.t) :: %Post{}
  @decorate cacheable(cache: Cache, key: {:posts, slug}, opts: [ttl: @ttl])
  def show(slug) do
    query = ~S"""
    *[_type == "post" && slug.current == $slug][0]{
      ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      categories[] -> {...},
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

  @spec count(Keyword.t) :: integer
  def count(options \\ []) do
    category = Keyword.get(options, :category)

    query = ~S"""
    count(*[_type == "post" && (featured != true || defined($category))])
    """

    %Sanity.Response{body: %{"result" => posts_count}} =
      query
      |> Sanity.query(%{category: category}, perspective: "published")
      |> Sanity.request!(request_opts())

    posts_count
  end
end
