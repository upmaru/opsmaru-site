defmodule OpsmaruWeb.HomeComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Pages
  alias Opsmaru.Content.Image

  alias OpsmaruWeb.BaseComponents

  attr :section, Pages.Section, required: true

  def hero(assigns) do
    h1 = Enum.find(assigns.section.contents, &(&1.slug == "home-hero-title"))
    description = Enum.find(assigns.section.contents, &(&1.slug == "home-hero-description"))

    assigns =
      assigns
      |> assign(:h1, h1)
      |> assign(:description, description)

    ~H"""
    <div class="pb-24 pt-16 sm:pb-32 sm:pt-24 md:pb-48 md:pt-32">
      <h1 class="font-display text-balance text-6xl/[0.9] font-medium tracking-tight text-slate-950 sm:text-8xl/[0.8] md:text-9xl/[0.8]">
        <%= @h1.body %>
      </h1>
      <p class="mt-8 max-w-lg text-xl/7 font-medium text-slate-950/75 sm:text-2xl/8">
        <%= @description.body %>
      </p>
      <div class="mt-12 flex flex-col gap-x-6 gap-y-4 sm:flex-row">
        <BaseComponents.button href="/auth/users/log_in">
          <%= gettext("Get started") %>
        </BaseComponents.button>
        <BaseComponents.button href={~p"/our-product/pricing"} variant={:secondary}>
          <%= gettext("See pricing") %>
        </BaseComponents.button>
      </div>
    </div>
    """
  end

  attr :section, Pages.Section, required: true
  attr :slides, :list, required: true

  def slides(assigns) do
    h2 = Enum.find(assigns.section.contents, &(&1.slug == "home-slides-title"))

    assigns =
      assigns
      |> assign(:h2, h2)

    ~H"""
    <div class="overflow-x-clip">
      <div class="pb-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-slate-950 sm:text-6xl">
            <%= @h2.body %>
          </h2>
        </div>
      </div>
      <div
        id="slides"
        class="h-[300vh] bg-gradient-to-b from-slate-950 from-50% to-slate-900 relative overflow-clip"
        phx-hook="MountSlideScroll"
      >
        <div>
          <div
            class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.slate.500)_var(--opacity),transparent)_100%)] ring-1 ring-inset ring-slate-100/[8%]"
            style="--opacity: 7%; width: 2560px; height: 2560px;"
          >
          </div>
          <div
            class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.slate.500)_var(--opacity),transparent)_100%)] ring-1 ring-inset ring-slate-100/[8%]"
            style="--opacity: 7%; width: 1920px; height: 1920px;"
          >
          </div>
          <div
            class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.slate.500)_var(--opacity),transparent)_100%)] ring-1 ring-inset ring-slate-100/[8%]"
            style="--opacity: 7%; width: 1600px; height: 1600px;"
          >
          </div>
          <div
            class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.slate.500)_var(--opacity),transparent)_100%)] ring-1 ring-inset ring-slate-100/[8%]"
            style="--opacity: 7%; width: 1280px; height: 1280px;"
          >
          </div>
          <div
            class="absolute left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-full bg-[radial-gradient(circle,transparent_25%,color-mix(in_srgb,_theme(colors.slate.500)_var(--opacity),transparent)_100%)] ring-1 ring-inset ring-slate-100/[8%]"
            style="--opacity: 7%; width: 960px; height: 960px;"
          >
          </div>
        </div>
        <div id="slides-container" class="flex sticky top-0">
          <div
            :for={slide <- @slides}
            class="slide-item flex flex-col flex-none items-center justify-center w-screen h-screen overflow-hidden"
          >
            <h2 class="slide-title bg-gradient-to-r from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 font-semibold text-transparent bg-clip-text text-xl md:text-4xl lg:text-6xl p-2">
              <%= slide.title %>
            </h2>
            <div class="slide-description rounded-full mb-12 md:mb-16 lg:mb-24">
              <p class="text-white font-light text-center text-lg md:text-xl lg:text-4xl font-light">
                <%= slide.subtitle %>
              </p>
            </div>
            <div class="w-96 h-64 md:w-[600px] md:h-[400px] lg:w-[960px] lg:h-[640px] xl:w-[1050px] xl:h-[700px] relative aspect-[var(--width)/var(--height)] [--radius:theme(borderRadius.xl)]">
              <div class="absolute -inset-[var(--padding)] bg-black/10 rounded-[calc(var(--radius)+var(--padding))] shadow-sm ring-1 ring-slate-700 [--padding:theme(spacing.2)] md:[--padding:theme(spacing.4)]">
              </div>
              <img
                src={Image.url(slide.image, format: "jpeg", w: 2160)}
                alt={slide.image.alt}
                class="h-full rounded-[var(--radius)] shadow-2xl ring-1 ring-slate-700"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :technologies, :list, required: true

  def technologies(assigns) do
    ~H"""
    <div class="lg:col-span-2 group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <div
        id="technologies"
        data-technologies={Jason.encode!(@technologies)}
        class="relative h-80 shrink-0"
        phx-hook="MountTechnologies"
      >
        <div class="relative h-full overflow-hidden">
          <div class="absolute inset-0"></div>
          <div class="absolute left-1/2 h-full w-[26rem] -translate-x-1/2"></div>
        </div>
      </div>
      <div class="relative p-10">
        <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
          <%= gettext("Framework") %>
        </h3>
        <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
          <%= gettext("Support multiple frameworks") %>
        </p>
        <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
          <%= gettext("Opsmaru supports a variety of languages and frameworks out of the box.") %>
        </p>
      </div>
    </div>
    """
  end
end
