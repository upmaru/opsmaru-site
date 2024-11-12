defmodule OpsmaruWeb.BlogLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Pages

  alias OpsmaruWeb.BlogComponents

  @per_page 5

  def mount(_params, _session, socket) do
    page = Content.show_page("blog")
    header_section = Enum.find(page.sections, &(&1.slug == "blog-header"))
    featured_posts = Content.featured_posts()
    posts_count = Content.posts_count()
    posts = Content.list_posts(end_index: @per_page)

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:featured_posts, featured_posts)
      |> assign(:posts_count, posts_count)
      |> assign(:posts, posts)
      |> assign(:pages, ceil(posts_count / @per_page))
      |> assign(:current_page, 1)

    {:ok, socket}
  end

  attr :mobile_nav_active, :boolean, default: false
  attr :header_section, Pages.Section, required: true
  attr :featured_posts, :list, required: true
  attr :posts_count, :integer, required: true
  attr :pages, :integer, required: true
  attr :current_page, :integer, default: 1
  attr :posts, :list, default: []

  def render(assigns) do
    ~H"""
    <div>
      <BlogComponents.header section={@header_section} />
      <BlogComponents.featured :if={@current_page == 1} posts={@featured_posts} />
      <div class="mt-16 pb-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div class="flex flex-wrap items-center justify-between gap-2"></div>
          <div class="mt-6">
            <BlogComponents.post_listing :for={post <- @posts} post={post} />
          </div>
          <BlogComponents.pagination pages={@pages} current_page={@current_page} current_path={@current_path} />
        </div>
      </div>
    </div>
    """
  end

  def handle_params(%{"page" => page}, _url, %{assigns: assigns} = socket) do
    current_path = ~p"/blog?page=#{page}"

    page = String.to_integer(page)
    last_post = List.last(assigns.posts)

    last_id = last_post.id
    last_published_at = last_post.published_at

    posts =
      if page == assigns.current_page do
        assigns.posts
      else
        Content.list_posts(
          end_index: @per_page,
          last_id: last_id,
          last_published_at: last_published_at
        )
      end

    socket =
      socket
      |> assign(:current_page, page)
      |> assign(:current_path, current_path)
      |> assign(:posts, posts)

    {:noreply, socket}
  end

  def handle_params(_params, _url, socket) do
    current_path = ~p"/blog"

    posts = Content.list_posts(end_index: @per_page)

    socket =
      socket
      |> assign(:current_page, 1)
      |> assign(:current_path, current_path)
      |> assign(:posts, posts)

    {:noreply, socket}
  end
end
