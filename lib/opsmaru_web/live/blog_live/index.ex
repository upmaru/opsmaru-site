defmodule OpsmaruWeb.BlogLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Pages
  alias Opsmaru.Posts

  alias OpsmaruWeb.BlogComponents

  @per_page 5

  def mount(_params, _session, socket) do
    page = Content.show_page("blog")
    header_section = Enum.find(page.sections, &(&1.slug == "blog-header"))
    featured_posts = Content.featured_posts()
    categories = Posts.list_categories()

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:featured_posts, featured_posts)
      |> assign(:posts_count, 0)
      |> assign(:posts, [])
      |> assign(:current_page, 1)
      |> assign(:pages, 1)
      |> assign(:categories, categories)

    {:ok, socket}
  end

  attr :header_section, Pages.Section, required: true
  attr :featured_posts, :list, required: true
  attr :posts_count, :integer, required: true
  attr :pages, :integer, default: 1
  attr :current_page, :integer, default: 1
  attr :posts, :list, default: []
  attr :category, :string, default: nil

  def render(assigns) do
    ~H"""
    <div>
      <BlogComponents.header section={@header_section} />
      <BlogComponents.featured :if={@current_page == 1 && is_nil(@category)} posts={@featured_posts} />
      <div class="mt-16 pb-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div class="flex flex-wrap items-center justify-between gap-2">
            <div
              id="categories"
              data-categories={Jason.encode!(@categories)}
              data-selected={@category}
              phx-hook="MountCategories"
            >
            </div>
            <.link
              href={~p"/blog/rss.xml"}
              class="gap-1 inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
            >
              <.icon name="hero-rss" class="w-4 h-4" />
              <%= gettext("RSS Feed") %>
            </.link>
          </div>
          <div class="mt-6">
            <BlogComponents.post_listing :for={post <- @posts} post={post} />
          </div>
          <BlogComponents.pagination
            :if={@pages > 1}
            pages={@pages}
            current_page={@current_page}
            current_path={@current_path}
          />
        </div>
      </div>
    </div>
    """
  end

  def handle_params(%{"page" => page} = params, _url, %{assigns: assigns} = socket) do
    category = Map.get(params, "category")

    posts_count = Content.posts_count(category: category)

    current_path = ~p"/blog?page=#{page}"

    page = String.to_integer(page)
    last_post = List.last(assigns.posts)

    last_post =
      if last_post do
        last_post
      else
        Content.list_posts(
          end_index: @per_page,
          category: category,
          perspective: assigns.perspective
        )
        |> List.last()
      end

    last_id = last_post.id
    last_published_at = last_post.published_at

    posts =
      if page == assigns.current_page do
        assigns.posts
      else
        Content.list_posts(
          end_index: @per_page,
          last_id: last_id,
          last_published_at: last_published_at,
          perspective: assigns.perspective
        )
      end

    socket =
      socket
      |> assign(:current_page, page)
      |> assign(:current_path, current_path)
      |> assign(:posts, posts)
      |> assign(:posts_count, posts_count)
      |> assign(:pages, ceil(posts_count / @per_page))
      |> assign(:category, category)

    {:noreply, socket}
  end

  def handle_params(params, _url, %{assigns: assigns} = socket) do
    category = Map.get(params, "category")

    current_path =
      if category do
        ~p"/blog?category=#{category}"
      else
        ~p"/blog"
      end

    posts =
      Content.list_posts(
        end_index: @per_page,
        category: category,
        perspective: assigns.perspective
      )

    posts_count = Content.posts_count(category: category)

    socket =
      socket
      |> assign(:current_page, 1)
      |> assign(:current_path, current_path)
      |> assign(:posts, posts)
      |> assign(:category, category)
      |> assign(:posts_count, posts_count)
      |> assign(:pages, ceil(posts_count / @per_page))

    {:noreply, socket}
  end
end
