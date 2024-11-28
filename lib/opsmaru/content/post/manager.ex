defmodule Opsmaru.Content.Post.Manager do
  use Nebulex.Caching
  import Opsmaru.Sanity

  alias Opsmaru.Sanity.Response

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

  @spec featured(Keyword.t()) :: %{data: [%Post{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def list(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    start_index = Keyword.get(options, :start_index, 0)
    end_index = Keyword.get(options, :end_index, 5)
    category = Keyword.get(options, :category)
    last_id = Keyword.get(options, :last_id, "")
    last_published_at = Keyword.get(options, :last_published_at, Date.utc_today())

    data =
      @base_query
      |> Sanity.query(
        %{
          start_index: start_index,
          end_index: end_index,
          category: category,
          last_id: last_id,
          last_published_at: last_published_at
        },
        perspective: perspective
      )
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Post.parse/1)

    %Response{data: data, perspective: perspective}
  end

  @spec featured(Keyword.t()) :: %{data: [%Post{}], perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def featured(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

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

    data =
      query
      |> Sanity.query(%{featured: true, limit: limit}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Post.parse/1)

    %Response{data: data, perspective: perspective}
  end

  @spec show(String.t(), Keyword.t()) :: %{data: %Post{}, perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: @ttl])
  def show(slug, options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

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
      |> Sanity.query(%{slug: slug}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())

    post = Post.parse(post_params)
    full_content = Req.get!(post.content).body
    %Response{data: %{post | content: full_content}, perspective: perspective}
  end

  @spec feed(Keyword.t()) :: [%Post{}]
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(24)])
  def feed(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    query = ~S"""
    *[_type == "post" && defined(slug.current)] | order(featured, published_at desc) {
     ...,
      author -> {..., "avatar": {"url": avatar.asset -> url, "alt": avatar.alt}},
      categories[] -> {...},
      "cover": {"url": cover.asset -> url, "alt": cover.alt},
      "content": content.asset -> url
    }
    """

    data =
      query
      |> Sanity.query(%{}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()
      |> Enum.map(&Post.parse/1)

    %{data: data, perspective: perspective}
  end

  @spec count(Keyword.t()) :: %{data: integer, perspective: String.t()}
  @decorate cacheable(cache: Cache, match: &sanity_cache?/1, opts: [ttl: :timer.hours(24)])
  def count(options \\ []) do
    perspective = Keyword.get(options, :perspective, "published")

    category = Keyword.get(options, :category)

    query = ~S"""
    count(*[_type == "post"
      && (featured != true || defined($category))
      && select(defined($category) => $category in categories[] -> slug.current, true)
    ])
    """

    data =
      query
      |> Sanity.query(%{category: category}, perspective: perspective)
      |> Sanity.request!(sanity_request_opts())
      |> Sanity.result!()

    %Response{data: data, perspective: perspective}
  end
end
