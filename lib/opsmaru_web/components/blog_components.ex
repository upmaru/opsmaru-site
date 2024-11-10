defmodule OpsmaruWeb.BlogComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Pages
  alias Opsmaru.Content

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
    <div class="mx-auto max-w-2xl lg:max-w-7xl">
      <h2 class="mt-16 font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
        <%= @h2.body %>
      </h2>
      <h1 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
        <%= @title.body %>
      </h1>
      <p class="mt-6 max-w-3xl text-2xl font-medium text-gray-500"><%= @description.body %></p>
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
          <div class="mt-6 grid grid-cols-1 gap-8 lg:grid-cols-3"></div>
        </div>
      </div>
    </div>
    """
  end

  attr :post, Content.Post, required: true

  def featured_post(assigns) do
    ~H"""
    <div class="relative flex flex-col rounded-3xl bg-white p-2 shadow-md shadow-black/5 ring-1 ring-black/5">
    </div>
    """
  end
end
