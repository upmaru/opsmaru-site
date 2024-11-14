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
      <div id="slides" class="h-[200vh] bg-gradient-to-b from-slate-950 from-25% to-slate-900 relative" phx-hook="MountSlideScroll">
        <div id="slides-container" class="flex sticky top-0">
          <div :for={slide <- @slides} class="slide-item flex flex-col flex-none items-center justify-center w-screen h-screen overflow-hidden">
            <div class="w-96 h-56 md:w-[640px] md:h-[375px] lg:w-[960px] lg:h-[562px] xl:w-[1200px] xl:h-[704px] relative aspect-[var(--width)/var(--height)] [--radius:theme(borderRadius.xl)]">
              <div class="absolute -inset-[var(--padding)] rounded-[calc(var(--radius)+var(--padding))] shadow-sm ring-1 ring-white/10 [--padding:theme(spacing.2)]"></div>
              <img
                src={Image.url(slide.image, format: "jpeg")}
                alt={slide.image.alt}
                class="h-full rounded-[var(--radius)] shadow-2xl ring-1 ring-white/10"
              />
            </div>
            <div class="bg-slate-800/50 mt-16 rounded-full px-6 py-4">
              <h2 class="text-white font-light text-center sm:text-lg"><%= slide.title %></h2>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end