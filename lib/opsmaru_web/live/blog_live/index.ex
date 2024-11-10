defmodule OpsmaruWeb.BlogLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Pages

  alias OpsmaruWeb.BlogComponents

  def mount(_params, _session, socket) do
    page = Content.show_page("blog")
    header_section = Enum.find(page.sections, &(&1.slug == "blog-header"))
    featured_posts = Content.featured_posts()

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:featured_posts, featured_posts)

    {:ok, socket}
  end

  attr :header_section, Pages.Section, required: true
  attr :featured_posts, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <BlogComponents.header section={@header_section} />
      <BlogComponents.featured posts={@featured_posts} />
    </div>
    """
  end
end
