defmodule OpsmaruWeb.CourseComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Courses
  alias Opsmaru.Content
  alias Opsmaru.Pages

  alias Opsmaru.Content.Video
  alias Opsmaru.Content.Image

  import OpsmaruWeb.MarkdownHelper

  attr :sections, :list, required: true
  attr :course, Content.Course, required: true
  attr :current_episode, Courses.Episode, default: nil

  def playlist(assigns) do
    ~H"""
    <ul class="divide-y divide-slate-100">
      <li :for={section <- @sections}>
        <h4 class="-mx-4 rounded-lg bg-gray-50 px-4 py-3 text-sm/6 font-semibold">
          <%= gettext("Chapter") %> <%= section.index %>
          <.icon name="hero-ellipsis-vertical" class="w-3 h-3 text-slate-700" />
          <%= section.chapter.title %>
        </h4>
        <ul>
          <li
            :for={episode <- section.chapter.episodes}
            class="border-b border-dotted border-gray-200 text-sm/6 font-normal"
          >
            <.link
              :if={is_nil(@current_episode) || @current_episode.id != episode.id}
              navigate={~p"/how-to/#{@course.slug}/#{episode.slug}"}
              class="px-0 py-4 group w-full flex items-center cursor-pointer"
            >
              <div class="pr-3 w-8 text-slate-600"><%= section.index %>.<%= episode.index %></div>
              <div class="flex-grow"><%= episode.title %></div>
              <div><%= Video.duration_display(episode.video) %></div>
              <div class="flex items-center justify-center rounded-full ml-2">
                <.icon name="hero-play-circle-solid" class="w-8 h-8 text-indigo-400" />
              </div>
            </.link>
            <span
              :if={@current_episode && @current_episode.id == episode.id}
              class="px-0 py-4 group w-full flex items-center"
            >
              <div class="pr-3 w-8 text-slate-400"><%= section.index %>.<%= episode.index %></div>
              <div class="flex-grow text-slate-400"><%= episode.title %></div>
              <div class="text-slate-400"><%= Video.duration_display(episode.video) %></div>
              <div class="flex items-center justify-center rounded-full ml-2">
                <.icon name="hero-play-circle-solid" class="w-8 h-8 text-indigo-200" />
              </div>
            </span>
          </li>
        </ul>
      </li>
    </ul>
    """
  end

  def header(assigns) do
    h2 = Enum.find(assigns.section.contents, &(&1.slug == "learn-header-h2"))
    title = Enum.find(assigns.section.contents, &(&1.slug == "learn-header-title"))
    description = Enum.find(assigns.section.contents, &(&1.slug == "learn-header-description"))

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

  attr :section, Pages.Section, required: true

  def get_support(assigns) do
    h2 = Enum.find(assigns.section.contents, &(&1.slug == "learn-get-support-h2"))
    title = Enum.find(assigns.section.contents, &(&1.slug == "learn-get-support-title"))

    description =
      Enum.find(assigns.section.contents, &(&1.slug == "learn-get-support-description"))

    content = Enum.find(assigns.section.contents, &(&1.slug == "learn-get-support-content"))
    card = Enum.find(assigns.section.cards, &(&1.slug == "learn-get-support-card"))

    assigns =
      assigns
      |> assign(:h2, h2)
      |> assign(:title, title)
      |> assign(:description, description)
      |> assign(:content, content)
      |> assign(:card, card)

    ~H"""
    <div class="my-32 px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:max-w-7xl">
        <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500">
          <%= @h2.body %>
        </h2>
        <h3 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-slate-950 sm:text-6xl">
          <%= @title.body %>
        </h3>
        <p class="mt-6 max-w-3xl text-2xl font-medium text-slate-500"><%= @description.body %></p>
        <div class="mt-24 grid grid-cols-1 gap-16 lg:grid-cols-[1fr_24rem]">
          <div class="max-w-lg">
            <div class="prose text-slate-600">
              <%= raw(render_markdown(@content.body)) %>
            </div>
            <div class="mt-6">
              <a
                href="https://discord.gg/gPFvN9QW"
                class="w-full sm:w-auto inline-flex items-center justify-center px-4 py-[calc(theme(spacing.2)-1px)] rounded-full border border-transparent bg-gray-950 shadow-md whitespace-nowrap text-base font-medium text-white data-[disabled]:bg-gray-950 data-[hover]:bg-gray-800 data-[disabled]:opacity-40"
              >
                <%= gettext("Join Discord") %>
              </a>
              <a
                href="https://cal.com/zacksiri/opsmaru-onboarding"
                class="w-full sm:w-auto mt-6 sm:ml-2 inline-flex items-center justify-center px-4 py-[calc(theme(spacing.2)-1px)] rounded-full border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-base font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
              >
                <%= gettext("Book a call") %>
              </a>
            </div>
          </div>
          <div class="relative flex aspect-square flex-col justify-end overflow-hidden rounded-3xl sm:aspect-[5/4] lg:aspect-[3/4]">
            <img src={Image.url(@card.cover, w: 600)} class="absolute inset-0 object-cover" />
            <div class="absolute inset-0 rounded-3xl bg-gradient-to-t from-black from-10% to-75% ring-1 ring-inset ring-gray-950/10 lg:from-25%">
            </div>
            <figure class="relative p-10">
              <blockquote>
                <p class="relative text-md text-white before:absolute before:-translate-x-full">
                  <%= @card.description %>
                </p>
              </blockquote>
              <figcaption class="mt-6 border-t border-white/20 pt-6">
                <p class="text-sm/6 font-medium text-white"><%= @card.heading %></p>
                <p class="text-sm/6 font-medium">
                  <span class="bg-gradient-to-r from-cyan-300 from-[28%] via-[#c084fc] via-[70%] to-[#7c3aed] bg-clip-text text-transparent">
                    <%= @card.title %>
                  </span>
                </p>
              </figcaption>
            </figure>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :categories, :list, required: true

  def categories(assigns) do
    ~H"""
    <div class="my-32 px-6 lg:px-8">
      <.category :for={category <- @categories} category={category} />
    </div>
    """
  end

  attr :category, Courses.Category, required: true
  attr :template, :string, default: nil

  def category(%{category: %{template: "course-cover-with-category-description"}} = assigns) do
    ~H"""
    <div id={@category.slug} class="mx-auto max-w-2xl lg:max-w-7xl">
      <h3 class="mt-24 font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500">
        <%= @category.name %>
      </h3>
      <hr class="mt-6 border-t border-slate-200" />
      <div class="mt-10 grid grid-cols-1 gap-20 g:px-8 xl:grid-cols-3">
        <div class="mx-auto max-w-2xl lg:mx-0">
          <h2 class="text-pretty text-4xl font-semibold tracking-tight text-slate-900 sm:text-5xl">
            <%= @category.title %>
          </h2>
          <p class="mt-6 max-w-3xl text-2xl font-medium text-slate-500">
            <%= @category.description %>
          </p>
        </div>
        <ul
          role="list"
          class="mx-auto grid max-w-2xl grid-cols-1 gap-x-6 gap-y-20 sm:grid-cols-2 lg:mx-0 lg:max-w-none lg:gap-x-8 xl:col-span-2"
        >
          <li :for={course <- @category.courses}>
            <img
              class="aspect-[3/2] w-full rounded-2xl object-cover"
              src={Image.url(course.cover, w: 600)}
              alt={course.cover.alt}
            />
            <h3 class="mt-6 text-lg/8 font-semibold text-slate-900"><%= course.title %></h3>
            <p class="mt-4 text-base/7 text-slate-600"><%= course.description %></p>
            <.link
              navigate={~p"/how-to/#{course.slug}"}
              class="mt-8 inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
            >
              <%= gettext("View course") %>
            </.link>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def category(%{category: %{template: "full-width-with-course-cover"}} = assigns) do
    ~H"""
    <div id={@category.slug} class="mx-auto max-w-2xl lg:max-w-7xl">
      <h2 class="mt-24 font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500">
        <%= @category.name %>
      </h2>
      <h3 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
        <%= @category.title %>
      </h3>
      <p class="mt-6 max-w-3xl text-2xl font-medium text-gray-500"><%= @category.description %></p>
      <ul
        role="list"
        class="mx-auto mt-20 grid max-w-2xl grid-cols-1 gap-x-6 gap-y-20 sm:grid-cols-2 lg:max-w-4xl lg:gap-x-8 xl:max-w-none"
      >
        <li :for={course <- @category.courses} class="flex flex-col gap-6 xl:flex-row">
          <img
            class="aspect-[4/5] w-52 flex-none rounded-2xl object-cover"
            src={Image.url(course.cover, w: 600)}
            alt={course.cover.alt}
          />
          <div class="flex-auto">
            <h3 class="text-lg/8 font-semibold tracking-tight text-gray-900"><%= course.title %></h3>
            <p class="text-base/7 text-gray-600">
              <%= course.main_technology.title %> - <%= course.main_technology.category.name %>
            </p>
            <p class="mt-6 text-base/7 text-gray-600"><%= course.description %></p>
            <.link
              navigate={~p"/how-to/#{course.slug}"}
              class="mt-8 inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
            >
              <%= gettext("View course") %>
            </.link>
          </div>
        </li>
      </ul>
    </div>
    """
  end

  def category(assigns) do
    ~H"""
    <div id={@category.slug} class="mx-auto max-w-2xl lg:max-w-7xl">
      <h3 class="mt-24 font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500">
        <%= @category.name %>
      </h3>
      <hr class="mt-6 border-t border-slate-200" />
      <ul role="list" class="mx-auto mt-10 grid grid-cols-1 gap-8 lg:grid-cols-2">
        <li :for={course <- @category.courses}>
          <img
            src={course.main_technology.logo.url}
            alt={course.main_technology.logo.alt}
            class="h-14"
          />
          <p class="mt-6 max-w-lg text-sm/6 text-slate-500">
            <%= course.description %>
          </p>
          <.link
            navigate={~p"/how-to/#{course.slug}"}
            class="mt-8 inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
          >
            <%= gettext("View course") %>
          </.link>
        </li>
      </ul>
    </div>
    """
  end

  attr :technologies, :list, required: true

  def technologies(assigns) do
    ~H"""
    <div class="my-32 px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:max-w-7xl">
        <h3 class="mt-24 font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500">
          <%= gettext("Tech Stack") %>
        </h3>
        <hr class="mt-6 border-t border-gray-200" />
        <ul class="mx-auto mt-16 grid grid-cols-1 gap-8 sm:grid-cols-2 lg:grid-cols-3" role="list">
          <li :for={technology <- @technologies} class="flex items-center gap-4">
            <div class="p-4 rounded-full ring-1 ring-slate-200">
              <img src={technology.logo.url} alt={technology.logo.alt} class="size-12" />
            </div>
            <div class="text-sm/6">
              <h3 class="font-medium"><%= technology.title %></h3>
              <p class="text-slate-500"><%= technology.category.name %></p>
            </div>
          </li>
        </ul>
      </div>
    </div>
    """
  end
end
