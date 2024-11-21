defmodule OpsmaruWeb.CourseComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Courses
  alias Opsmaru.Content

  alias Opsmaru.Content.Video

  attr :sections, :list, required: true
  attr :course, Content.Course, required: true
  attr :current_episode, Courses.Episode, default: nil

  def playlist(assigns) do
    ~H"""
    <ul class="divide-y divide-slate-100">
      <li :for={section <- @sections} class="bg-slate-300">
        <h4 class="text-lg font-medium text-slate-700 px-4 py-2">
          <%= gettext("Chapter") %> <%= section.index %>
          <.icon name="hero-ellipsis-vertical" class="w-3 h-3 text-slate-700" />
          <%= section.chapter.title %>
        </h4>
        <ul>
          <li :for={episode <- section.chapter.episodes} class="bg-white text-lg font-medium text-slate-900">
            <.link :if={is_nil(@current_episode) || @current_episode.id != episode.id}
                navigate={~p"/how-to/#{@course.slug}/#{episode.slug}"} class="group w-full px-5 py-2.5 text-[0.98rem] flex items-center cursor-pointer">
              <div class="pr-3 w-8 text-slate-600"><%= section.index %>.<%= episode.index %></div>
              <div class="flex-grow group-hover:text-slate-500"><%= episode.title %></div>
              <div><%= Video.duration_display(episode.video) %></div>
              <div class="flex items-center justify-center rounded-full ml-2">
                <.icon name="hero-play-circle-solid" class="w-8 h-8 text-indigo-400" />
              </div>
            </.link>
            <span :if={@current_episode && @current_episode.id == episode.id} class="group w-full px-5 py-2.5 text-[0.98rem] flex items-center">
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

  attr :categories, :list, required: true

  def categories(assigns) do
    infrastructure_setup_category =
      Enum.find(assigns.categories, &(&1.slug == "infrastructure-setup"))

    assigns = assign(assigns, :infrastructure_setup_category, infrastructure_setup_category)

    ~H"""
    <div class="my-32 px-6 lg:px-8">
      <.infrastructure_setup category={@infrastructure_setup_category} />
    </div>
    """
  end

  attr :category, Courses.Category, required: true

  def infrastructure_setup(assigns) do
    ~H"""
    <div id="infrastructure-setup" class="mx-auto max-w-2xl lg:max-w-7xl">
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
end
