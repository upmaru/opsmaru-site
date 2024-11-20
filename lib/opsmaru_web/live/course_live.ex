defmodule OpsmaruWeb.CourseLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Content.Image
  alias Opsmaru.Content.Video

  alias Opsmaru.Courses

  import OpsmaruWeb.MarkdownHelper

  def mount(%{"id" => slug}, _session, socket) do
    course = Content.show_course(slug)
    sections = Courses.list_sections(course_id: course.id)

    first_section = Enum.find(sections, fn section -> section.index == 1 end)
    first_episode = Enum.find(first_section.chapter.episodes, fn episode -> episode.index == 1 end)

    socket =
      socket
      |> assign(:course, course)
      |> assign(:sections, sections)
      |> assign(:first_episode, first_episode)

    {:ok, socket}
  end

  attr :course, Content.Course, required: true
  attr :sections, :list, required: true
  attr :first_episode, Courses.Episode, required: true

  def render(assigns) do
    ~H"""
    <div>
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="mt-16 font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
            <%= gettext("How to") %>
          </h2>
          <h1 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
            <%= @course.title %>
          </h1>
          <p class="mt-6 max-w-3xl text-xl font-medium text-gray-500">
            <%= @course.description %>
          </p>
        </div>
      </div>
      <div class="mt-16 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div id="introduction-player" class="aspect-[16/9] rounded-2xl overflow-hidden min-h-64 bg-slate-950 shadow-xl" data-video={Jason.encode!(@course.introduction)} data-title={@course.title} phx-hook="MountPlayer"></div>
        </div>
      </div>
      <div class="mt-16 px-6 lg:px-8">
        <div class="mx-auto max-w-7xl">
          <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-3">
            <div class="lg:col-start-3 lg:row-end-1">
              <div class="col-span-1 flex flex-col divide-y divide-slate-100 rounded-2xl bg-white text-center ring-1 ring-slate-200 shadow-md">
                <div class="flex flex-1 flex-col p-8">
                  <img class="mx-auto size-32 shrink-0 rounded-full" src={Image.url(@course.author.avatar, auto: "format", h: 256, w: 256, fit: "crop")} alt={@course.author.avatar.alt}>
                  <h3 class="mt-6 text-sm font-medium text-gray-900"><%= @course.author.name %></h3>
                  <dl class="mt-1 flex grow flex-col justify-between">
                    <dt class="sr-only"><%= gettext("Title") %></dt>
                    <dd class="text-sm text-gray-500"><%= @course.author.title %></dd>
                    <dt class="sr-only"><%= gettext("Role") %></dt>
                    <dd class="mt-3">
                      <span class="inline-flex items-center rounded-full bg-green-50 px-2 py-1 text-xs font-medium text-green-700 ring-1 ring-inset ring-green-600/20"><%= gettext("Instructor") %></span>
                    </dd>
                  </dl>
                </div>
                <.link navigate={~p"/how-to/#{@course.slug}/#{@first_episode.slug}"} class="px-5 py-5 bg-slate-950 text-md font-semibold text-white rounded-b-2xl">
                  <%= gettext("Start course") %>
                </.link>
              </div>
            </div>

            <div class="lg:col-span-2 lg:row-span-2 lg:row-end-2 prose max-w-max">
              <h2><%= gettext("Course Overview") %></h2>
              <%= raw(render_markdown(@course.overview)) %>
            </div>
          </div>
        </div>
      </div>
      <div class="mt-8 mb-32 px-6 lg:px-8">
        <div class="mx-auto max-w-7xl">
          <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-3">
            <div class="lg:col-span-2 lg:row-span-2 lg:row-end-2">
              <div class="overflow-hidden bg-white sm:rounded-2xl border border-slate-200">
                <div class="bg-slate-200 px-4 py-4 sm:px-4">
                  <h3 class="text-xl font-semibold text-slate-600"><%= gettext("Course episodes") %></h3>
                </div>
                <ul class="divide-y divide-slate-100">
                  <li :for={section <- @sections} class="bg-slate-300">
                    <h4 class="text-lg font-medium text-slate-700 px-4 py-2">
                      <%= gettext("Chapter") %> <%= section.index %>
                      <.icon name="hero-ellipsis-vertical" class="w-3 h-3 text-slate-700" />
                      <%= section.chapter.title %>
                    </h4>
                    <ul>
                      <li :for={episode <- section.chapter.episodes} class="bg-white text-lg font-medium text-slate-900">
                        <.link navigate={~p"/how-to/#{@course.slug}/#{episode.slug}"} class="group w-full px-5 py-2.5 text-[0.98rem] flex items-center cursor-pointer">
                          <div class="pr-3 w-8 text-slate-600"><%= section.index %>.<%= episode.index %></div>
                          <div class="flex-grow group-hover:text-slate-500"><%= episode.title %></div>
                          <div><%= Video.duration_display(episode.video) %></div>
                          <div class="flex items-center justify-center rounded-full ml-2">
                            <.icon name="hero-play-circle-solid" class="w-8 h-8 text-indigo-400" />
                          </div>
                        </.link>
                      </li>
                    </ul>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
