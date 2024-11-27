defmodule OpsmaruWeb.HomeLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content

  alias OpsmaruWeb.BaseComponents
  alias OpsmaruWeb.HomeComponents
  alias OpsmaruWeb.BlogComponents

  def mount(_params, _session, socket) do
    page = Content.show_page("home")

    hero_section = Enum.find(page.sections, &(&1.slug == "home-hero"))
    slides_section = Enum.find(page.sections, &(&1.slug == "home-slides"))
    top_bento_section = Enum.find(page.sections, &(&1.slug == "home-top-bento"))
    %{data: featured_posts} = Content.featured_posts()

    slides = Content.list_slides()

    logos = Content.list_logos()

    testimonials = Content.list_testimonials()

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:hero_section, hero_section)
      |> assign(:slides_section, slides_section)
      |> assign(:top_bento_section, top_bento_section)
      |> assign(:logos, logos)
      |> assign(:slides, slides)
      |> assign(:testimonials, testimonials)
      |> assign(:featured_posts, featured_posts)

    {:ok, socket, layout: false}
  end

  attr :mobile_nav_active, :boolean, default: false
  attr :main_nav, Content.Navigation, required: true
  attr :slides, :list, required: true
  attr :testimonials, :list, required: true
  attr :featured_posts, :list, default: []

  def render(assigns) do
    ~H"""
    <div>
      <div class="relative">
        <div class={[
          "absolute inset-2 bottom-0 rounded-4xl ring-1 ring-inset ring-slate-950/5",
          "bg-[linear-gradient(115deg,var(--tw-gradient-stops))] from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 sm:bg-[linear-gradient(145deg,var(--tw-gradient-stops))]"
        ]}>
        </div>
        <div class="relative px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <BaseComponents.header
              navigation={@main_nav}
              mobile_nav_active={@mobile_nav_active}
              current_user={@current_user}
            />
            <HomeComponents.hero section={@hero_section} />
          </div>
        </div>
      </div>
      <main>
        <div class="mt-16 px-6 lg:px-8">
          <div class="mx-auto max-w-xl lg:max-w-2xl">
            <div class="flex justify-between max-sm:mx-auto max-sm:max-w-md max-sm:flex-wrap max-sm:justify-evenly max-sm:gap-x-4 max-sm:gap-y-4">
              <img
                :for={logo <- @logos}
                alt={logo.name}
                src={logo.image}
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
            </div>
          </div>
        </div>
        <div class="bg-gradient-to-b from-white from-50% to-slate-100 py-32">
          <HomeComponents.slides section={@slides_section} slides={@slides} />
          <HomeComponents.top_bento section={@top_bento_section} />
        </div>
        <div class="mx-2 mt-2 rounded-4xl bg-slate-900 py-32">
          <div class="px-6 lg:px-8">
            <div class="mx-auto max-w-2xl lg:max-w-7xl">
              <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-400">
                <%= gettext("First class Day 2 Ops") %>
              </h2>
              <h3 class="mt-2 max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-white sm:text-6xl">
                <%= gettext("Monitor and observe your infrastructure and applications.") %>
              </h3>
              <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6 lg:grid-rows-2">
                <div class="max-lg:rounded-t-4xl lg:col-span-4 lg:rounded-tl-4xl group relative flex flex-col overflow-hidden rounded-lg shadow-sm ring-1 ring-black/5 bg-slate-800 ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10"></div>
                </div>
                <div class="z-10 lg:col-span-2 lg:rounded-tr-4xl group relative flex flex-col overflow-hidden rounded-lg shadow-sm ring-1 ring-black/5 bg-slate-800 ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10"></div>
                </div>
                <div class="lg:col-span-2 lg:rounded-bl-4xl group relative flex flex-col overflow-hidden rounded-lg shadow-sm ring-1 ring-black/5 bg-slate-800 ring-white/15">
                  <div
                    id="broadcast-graphics"
                    class="relative h-80 shrink-0"
                    phx-hook="MountBroadcast"
                  >
                  </div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 text-slate-400">
                      <%= gettext("Broadcasted Upgrade") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-white">
                      <%= gettext("Push updates to your buyers") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-slate-400">
                      <%= gettext(
                        "Opsmaru handles upgrades to multiple installations of your applications seamlessly."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="max-lg:rounded-b-4xl lg:col-span-4 lg:rounded-br-4xl group relative flex flex-col overflow-hidden rounded-lg shadow-sm ring-1 ring-black/5 bg-slate-800 ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
      <div class="overflow-hidden pt-32">
        <div class="px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <div>
              <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                <%= gettext("Latest updates") %>
              </h2>
              <h3 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
                <%= gettext("From the blog.") %>
              </h3>
            </div>
          </div>
        </div>
        <BlogComponents.featured posts={@featured_posts} />
      </div>
      <BaseComponents.footer />
    </div>
    """
  end
end
