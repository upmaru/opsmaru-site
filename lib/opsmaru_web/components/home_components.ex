defmodule OpsmaruWeb.HomeComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Pages
  alias Opsmaru.Content
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
    <div class="overflow-hidden">
      <div class="pb-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-slate-950 sm:text-6xl">
            <%= @h2.body %>
          </h2>
        </div>
      </div>
      <div
        id="slides"
        class="bg-gradient-to-b from-slate-950 from-50% to-slate-900 relative overflow-hidden py-64"
        phx-hook="MountSlideScroll"
      >
        <div id="slides-container" class="relative">
          <div
            :for={slide <- @slides}
            class="slide-item flex items-center justify-center h-screen"
          >
            <div>
              <h2 class="slide-title text-center bg-gradient-to-r from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 font-semibold text-transparent bg-clip-text text-3xl md:text-4xl lg:text-6xl p-2">
                <%= slide.title %>
              </h2>
              <div class="slide-description rounded-full mb-12 md:mb-16 lg:mb-24">
                <p class="text-white font-light text-center text-lg md:text-xl lg:text-4xl font-light">
                  <%= slide.subtitle %>
                </p>
              </div>
              <div class="w-96 h-64 sm:w-[576px] sm:h-[384px] md:w-[704px] md:h-[469px] lg:w-[960px] lg:h-[640px] xl:w-[1216px] xl:h-[811px] 2xl:w-[1472px] 2xl:h-[981px] relative aspect-[var(--width)/var(--height)] [--radius:theme(borderRadius.xl)]">
                <div class="absolute -inset-[var(--padding)] shadow-[inset_0_0_20px_5px_#1e293b] rounded-[calc(var(--radius)+var(--padding))] ring-1 ring-slate-700 [--padding:theme(spacing.2)] md:[--padding:theme(spacing.4)]">
                </div>
                <img
                  src={Image.url(slide.image, w: 2560)}
                  alt={slide.image.alt}
                  class="h-full aspect-[3/2] rounded-[var(--radius)] shadow-2xl"
                />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :section, Pages.Section, required: true

  def top_bento(assigns) do
    h2 = Enum.find(assigns.section.contents, &(&1.slug == "home-top-bento-title"))
    description = Enum.find(assigns.section.contents, &(&1.slug == "home-top-bento-description"))

    assigns =
      assigns
      |> assign(:h2, h2)
      |> assign(:description, description)

    ~H"""
    <div class="mt-16 px-6 lg:px-8">
      <div class="mx-auto max-w-2xl lg:max-w-7xl">
        <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500">
          <%= @h2.body %>
        </h2>
        <h3 class="mt-2 max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
          <%= @description.body %>
        </h3>
        <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6 lg:grid-rows-2">
          <.top_left card={Enum.find(@section.cards, &(&1.position == "top-left"))} />
          <.top_right card={Enum.find(@section.cards, &(&1.position == "top-right"))} />
          <.bottom_left card={Enum.find(@section.cards, &(&1.position == "bottom-left"))} />
          <.bottom_middle card={Enum.find(@section.cards, &(&1.position == "bottom-center"))} />
          <.bottom_right card={Enum.find(@section.cards, &(&1.position == "bottom-right"))} />
        </div>
      </div>
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  def top_left(assigns) do
    ~H"""
    <div class="max-lg:rounded-t-4xl lg:col-span-3 lg:rounded-tl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <div class="relative h-80 shrink-0">
        <div class="h-80 bg-[size:978px_345px] bg-[left_-8px_top_-12px] bg-no-repeat" style={"background-image: url(#{@card.cover.url})"}></div>
        <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]"></div>
      </div>
      <.card_content card={@card} />
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  def top_right(assigns) do
    ~H"""
    <div class="lg:col-span-3 lg:rounded-tr-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <div class="relative h-80 shrink-0">
        <div class="absolute inset-0 bg-[size:1100px_647px] bg-[left_-12px_top_-15px] bg-no-repeat" style={"background-image: url(#{@card.cover.url})"}>
        </div>
        <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]">
        </div>
      </div>
      <.card_content card={@card} />
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  def bottom_left(assigns) do
    ~H"""
     <div class="lg:col-span-2 lg:rounded-bl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <div class="relative h-80 shrink-0">
        <div class="absolute inset-0 bg-[size:720px_337px] bg-[left_0px_top_0px] bg-no-repeat" style={"background-image: url(#{@card.cover.url})"}>
        </div>
        <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]">
        </div>
      </div>
      <.card_content card={@card} />
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  def bottom_middle(assigns) do
    ~H"""
    <div class="lg:col-span-2 group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <.technologies :if={@card.hook == "MountTechnologies"} />
      <.card_content card={@card} />
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  def bottom_right(assigns) do
    ~H"""
    <div class="max-lg:rounded-b-4xl lg:col-span-2 lg:rounded-br-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
      <div class="relative h-80 shrink-0">
        <div class="absolute inset-0 bg-[size:720px_556px] bg-[left_-10px_top_-25px] bg-no-repeat" style={"background-image: url(#{@card.cover.url})"}>
        </div>
        <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]">
        </div>
      </div>
      <.card_content card={@card} />
    </div>
    """
  end

  attr :card, Pages.Card, required: true

  defp card_content(assigns) do
    ~H"""
    <div class="relative p-10">
      <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
        <%= @card.heading %>
      </h3>
      <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
        <%= @card.title %>
      </p>
      <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
        <%= @card.description %>
      </p>
    </div>
    """
  end

  defp technologies(assigns) do
    technologies = Content.list_technologies()

    assigns = assign(assigns, :technologies, technologies)

    ~H"""
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
    """
  end


end
