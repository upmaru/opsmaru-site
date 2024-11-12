defmodule OpsmaruWeb.BlogComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Pages
  alias Opsmaru.Content
  alias Opsmaru.Content.Image

  attr :section, Pages.Section

  def header(assigns) do
    h2 = Enum.find(assigns.section.contents, &(&1.slug == "blog-header-h2"))
    title = Enum.find(assigns.section.contents, &(&1.slug == "blog-header-title"))
    description = Enum.find(assigns.section.contents, &(&1.slug == "blog-header-description"))

    assigns =
      assigns
      |> assign(:h2, h2)
      |> assign(:title, title)
      |> assign(:description, description)

    ~H"""
    <div class="px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:max-w-7xl">
        <h2 class="mt-16 font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
          <%= @h2.body %>
        </h2>
        <h1 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
          <%= @title.body %>
        </h1>
        <p class="mt-6 max-w-3xl text-2xl font-medium text-gray-500">
          <%= @description.body %>
        </p>
      </div>
    </div>
    """
  end

  attr :posts, :list, required: true

  def featured(assigns) do
    ~H"""
    <div class="mt-16 bg-gradient-to-t from-gray-100 pb-14">
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="text-2xl font-medium tracking-tight"><%= gettext("Featured") %></h2>
          <div class="mt-6 grid grid-cols-1 gap-8 lg:grid-cols-3">
            <.featured_post :for={post <- @posts} post={post} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :post, Content.Post, required: true

  def featured_post(assigns) do
    ~H"""
    <div class="relative flex flex-col rounded-3xl bg-white p-2 shadow-md shadow-black/5 ring-1 ring-black/5">
      <img
        class="aspect-[3/2] w-full rounded-2xl object-cover"
        alt={@post.cover.alt}
        src={Image.url(@post.cover, w: 600)}
      />
      <div class="flex flex-1 flex-col p-8">
        <div class="text-sm/5 text-gray-700">
          <%= Calendar.strftime(@post.published_at, "%a, %B %d, %Y") %>
        </div>
        <div class="mt-2 text-base/7 font-medium">
          <.link navigate={~p"/blog/#{@post.slug}"}>
            <span class="absolute inset-0"></span>
            <%= @post.title %>
          </.link>
        </div>
        <div class="mt-2 flex-1 text-sm/6 text-gray-500">
          <%= @post.blurb %>
        </div>
        <div class="mt-6 flex items-center gap-3">
          <img
            class="aspect-square size-6 rounded-full object-cover"
            alt={@post.author.avatar.alt}
            src={Image.url(@post.author.avatar, w: 64)}
          />
          <div class="text-sm/5 text-gray-700"><%= @post.author.name %></div>
        </div>
      </div>
    </div>
    """
  end

  attr :post, Content.Post, required: true

  def post_listing(assigns) do
    ~H"""
    <div class="relative grid grid-cols-1 border-b border-b-gray-100 py-10 first:border-t first:border-t-gray-200 max-sm:gap-3 sm:grid-cols-3">
      <div>
        <div class="text-sm/5 max-sm:text-gray-700 sm:font-medium">
          <%= Calendar.strftime(@post.published_at, "%a, %B %d, %Y") %>
        </div>
        <div class="mt-2.5 flex items-center gap-3">
          <img
            class="aspect-square size-6 rounded-full object-cover"
            alt={@post.author.name}
            src={Image.url(@post.author.avatar, w: 64)}
          />
          <div class="text-sm/5 text-gray-700"><%= @post.author.name %></div>
        </div>
      </div>
      <div class="sm:col-span-2 sm:max-w-2xl">
        <h2 class="text-sm/5 font-medium"><%= @post.title %></h2>
        <p class="mt-3 text-sm/6 text-gray-500"><%= @post.blurb %></p>
        <div class="mt-4">
          <.link
            class="flex items-center gap-1 text-sm/5 font-medium"
            navigate={~p"/blog/#{@post.slug}"}
          >
            <span class="absolute inset-0"></span>
            <%= gettext("Read more") %>
            <.icon name="hero-chevron-right" class="h-4 w-4 text-slate-400" />
          </.link>
        </div>
      </div>
    </div>
    """
  end

  attr :pages, :integer, default: 1
  attr :current_page, :integer, default: 1
  attr :current_path, :string, default: "/blog"

  def pagination(assigns) do
    ~H"""
    <div class="mt-6 flex items-center justify-between gap-2">
      <.link
        patch={if @current_page in [1, 2], do: ~p"/blog", else: ~p"/blog?page=#{@current_page - 1}"}
        class="inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
        data-disabled={if @current_page == 1, do: true}
      >
        <.icon name="hero-chevron-left-solid" class="h-3 w-3 mr-1 text-slate-900" />
        <%= gettext("Previous page") %>
      </.link>
      <div class="flex gap-2 max-sm:hidden">
        <%= for p <- 1..@pages do %>
          <.link
            class="size-7 rounded-lg text-center text-sm/7 font-medium data-[hover]:bg-gray-100 data-[active]:shadow data-[active]:ring-1 data-[active]:ring-black/10 data-[active]:data-[hover]:bg-gray-50"
            patch={if p == 1, do: ~p"/blog", else: ~p"/blog?page=#{p}"}
            data-active={p == @current_page}
          >
            <%= p %>
          </.link>
        <% end %>
      </div>
      <.link
        patch={
          if @current_page == @pages, do: @current_path, else: ~p"/blog?page=#{@current_page + 1}"
        }
        class="inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
        data-disabled={if @current_page == @pages, do: true}
      >
        <%= gettext("Next page") %>
        <.icon name="hero-chevron-right-solid" class="h-3 w-3 ml-1 text-slate-900" />
      </.link>
    </div>
    """
  end
end
