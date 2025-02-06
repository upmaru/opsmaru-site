defmodule OpsmaruWeb.BlogLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Content.Image

  import OpsmaruWeb.MarkdownHelper

  def mount(%{"id" => slug}, _session, %{assigns: assigns} = socket) do
    %{data: post} = Content.show_post(slug, perspective: assigns.perspective)

    post_cover = Map.get(post, :cover) || %Image{}

    socket =
      socket
      |> assign(:page_title, post.title)
      |> assign(:page_description, post.blurb)
      |> assign(:page_cover_url, post_cover.url)
      |> assign(:post, post)

    {:ok, socket}
  end

  attr :mobile_nav_active, :boolean, default: false

  def render(assigns) do
    ~H"""
    <div>
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="mt-16 font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
            {Calendar.strftime(@post.published_at, "%a, %B %d, %Y")}
          </h2>
          <h1 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
            {@post.title}
          </h1>
        </div>
      </div>
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div class="mt-16 grid grid-cols-1 gap-8 pb-24 lg:grid-cols-[15rem_1fr]">
            <div class="flex flex-wrap items-center gap-8 max-lg:justify-between lg:flex-col lg:items-start">
              <div class="flex items-center gap-3">
                <img
                  class="aspect-square size-6 rounded-full object-cover"
                  alt={@post.author.name}
                  src={Image.url(@post.author.avatar, w: 64)}
                />
                <div class="text-sm/5 text-slate-700">{@post.author.name}</div>
              </div>
              <div class="flex flex-wrap gap-2">
                <.link
                  :for={category <- @post.categories}
                  class="rounded-full border border-dotted border-slate-300 bg-slate-50 px-2 text-sm/6 font-medium text-slate-500"
                  navigate={~p"/blog?category=#{category.slug}"}
                >
                  {category.name}
                </.link>
              </div>
            </div>
            <div class="text-slate-700">
              <div class="max-w-2xl md:max-w-2xl xl:max-w-5xl md:mx-auto">
                <img
                  class="mb-10 aspect-[3/2] w-full rounded-2xl object-cover shadow-xl"
                  alt={@post.cover.alt}
                  src={Image.url(@post.cover, w: 1024)}
                />
                <div class="prose prose-slate max-w-max prose-img:rounded-2xl prose-h2:font-medium lg:prose-lg">
                  {raw(render_markdown(@post.content))}
                </div>
                <div class="mt-10">
                  <.link
                    class="inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
                    navigate={~p"/blog"}
                  >
                    {gettext("Back to blog")}
                  </.link>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, :canonical_url, url)}
  end
end
