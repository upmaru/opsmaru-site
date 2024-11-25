defmodule OpsmaruWeb.EpisodeLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Courses

  alias Opsmaru.Content.Image

  alias OpsmaruWeb.CourseComponents

  import OpsmaruWeb.MarkdownHelper

  def mount(%{"course_id" => course_slug, "id" => episode_slug}, _session, socket) do
    course = Content.show_course(course_slug)
    episode = Courses.show_episode(course_slug, episode_slug)
    sections = Courses.list_sections(course_id: course.id)

    socket =
      socket
      |> assign(:course, course)
      |> assign(:episode, episode)
      |> assign(:sections, sections)

    {:ok, socket}
  end

  attr :course_slug, :string, required: true
  attr :course, Content.Course, required: true
  attr :episode, Courses.Episode, required: true
  attr :sections, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <div class="relative bg-slate-600 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl py-10">
          <div class="pb-8">
            <.link
              navigate={~p"/how-to/#{@course.slug}"}
              class="inline-flex items-center align-middle"
            >
              <.icon name="hero-chevron-left" class="w-4 h-4 text-slate-200" />
              <span class="ml-2 font-semibold text-slate-200"><%= gettext("Course overview") %></span>
            </.link>
          </div>
          <div
            id="episode-player"
            class="aspect-[16/9] content-center rounded-2xl overflow-hidden min-h-64 bg-slate-950"
            data-video={Jason.encode!(@episode.video)}
            data-title={@episode.title}
            phx-hook="MountPlayer"
          >
          </div>
        </div>
      </div>
      <div class="mt-16 mb-32 px-6 lg:px-8">
        <div class="mx-auto max-w-7xl">
          <div class="mx-auto grid max-w-2xl grid-cols-1 grid-rows-1 items-start gap-x-8 gap-y-8 lg:mx-0 lg:max-w-none lg:grid-cols-3">
            <div class="lg:col-start-3 lg:row-end-1">
              <CourseComponents.playlist
                current_episode={@episode}
                course={@course}
                sections={@sections}
              />
              <div :if={!@current_user} class="mt-8 bg-slate-100 rounded-xl px-5 py-4">
                <h3 class="font-semibold">
                  <%= gettext("Don't have an account?") %>
                </h3>
                <p class="pt-2 text-md text-slate-600">
                  <.link href="/auth/users/register" class="text-black underline">
                    <%= gettext("Sign up") %>
                  </.link>
                  <%= gettext("and get a 30 day free trial. No credit card required.") %>
                </p>
              </div>
              <div :if={@current_user} class="mt-8 bg-slate-100 rounded-xl px-5 py-4">
                <h3 class="font-semibold">
                  <%= gettext("You're signed in.") %>
                </h3>
                <p class="pt-2 text-md text-slate-600">
                  <.link href="/home" class="text-black underline">
                    <%= gettext("Open dashboard") %>
                  </.link>
                  <%= gettext("to follow along with the video.") %>
                </p>
              </div>
            </div>

            <div class="lg:col-span-2 lg:row-span-2 lg:row-end-2">
              <div class="flex items-center">
                <div class="text-3xl font-semibold -mb-1 mr-4 text-slate-400">
                  <%= @episode.section.index %>.<%= @episode.index %>
                </div>
                <h1 class="text-3xl font-semibold -mb-1"><%= @episode.title %></h1>
              </div>
              <div class="mt-8 prose max-w-max">
                <%= raw(render_markdown(@episode.content)) %>
              </div>
              <hr class="my-16" />
              <div>
                <h3 class="text-xl font-semibold my-8"><%= gettext("Instructor") %></h3>
                <div class="flex items-center">
                  <div>
                    <img
                      class="inline-block size-24 rounded-full"
                      src={
                        Image.url(@episode.author.avatar, w: 256, h: 256, format: "auto", fit: "crop")
                      }
                      alt={@episode.author.avatar.alt}
                    />
                  </div>
                  <div class="ml-6">
                    <p class="text-lg font-medium text-slate-700"><%= @episode.author.name %></p>
                    <p class="text font-medium text-slate-500"><%= @episode.author.title %></p>
                  </div>
                </div>
                <div class="mt-8 prose max-w-max">
                  <%= raw(render_markdown(@episode.author.bio)) %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
