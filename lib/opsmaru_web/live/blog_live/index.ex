defmodule OpsmaruWeb.BlogLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Pages

  alias OpsmaruWeb.BlogComponents

  def mount(_params, _session, socket) do
    page = Content.show_page("blog")
    header_section = Enum.find(page.sections, &(&1.slug == "blog-header"))
    featured_posts = Content.featured_posts()
    posts = Content.list_posts()

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:featured_posts, featured_posts)
      |> assign(:posts, posts)

    {:ok, socket}
  end

  attr :mobile_nav_active, :boolean, default: false
  attr :header_section, Pages.Section, required: true
  attr :featured_posts, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <BlogComponents.header section={@header_section} />
      <BlogComponents.featured posts={@featured_posts} />
      <div class="mt-16 pb-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div class="flex flex-wrap items-center justify-between gap-2"></div>
          <div class="mt-6">
            <BlogComponents.post_listing :for={post <- @posts} post={post} />
          </div>
        </div>
      </div>
    </div>
    """
  end
end
