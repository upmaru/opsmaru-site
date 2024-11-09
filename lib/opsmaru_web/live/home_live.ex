defmodule OpsmaruWeb.HomeLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content

  alias OpsmaruWeb.BaseComponents

  def mount(_params, _session, socket) do
    page = Content.show_page("home")

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)

    {:ok, socket, layout: false}
  end

  attr :mobile_nav_active, :boolean, default: false
  attr :main_nav, Content.Navigation, required: true

  def render(assigns) do
    ~H"""
    <div class="overflow-hidden">
      <div class="relative">
        <div class={[
          "absolute inset-2 bottom-0 rounded-4xl ring-1 ring-inset ring-slate-950/5",
          "bg-[linear-gradient(115deg,var(--tw-gradient-stops))] from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 sm:bg-[linear-gradient(145deg,var(--tw-gradient-stops))]"
        ]}>
        </div>
        <div class="relative px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <BaseComponents.header navigation={@main_nav} mobile_nav_active={@mobile_nav_active} />
            <div class="pb-24 pt-16 sm:pb-32 sm:pt-24 md:pb-48 md:pt-32">
              <h1 class="font-display text-balance text-6xl/[0.9] font-medium tracking-tight text-slate-950 sm:text-8xl/[0.8] md:text-9xl/[0.8]">
                <%= gettext("Monetize your web application.") %>
              </h1>
              <p class="mt-8 max-w-lg text-xl/7 font-medium text-slate-950/75 sm:text-2xl/8">
                <%= gettext(
                  "Opsmaru helps you setup the infrastructure that enables you to sell instances of your application."
                ) %>
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
          </div>
        </div>
      </div>
      <main>
        <div class="mt-10 px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <div class="flex justify-between max-sm:mx-auto max-sm:max-w-md max-sm:flex-wrap max-sm:justify-evenly max-sm:gap-x-4 max-sm:gap-y-4">
              <img
                alt="SavvyCal"
                src="/images/logo-cloud/savvycal.svg"
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
              <img
                alt="Laravel"
                src="/images/logo-cloud/laravel.svg"
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
              <img
                alt="Tuple"
                src="/images/logo-cloud/tuple.svg"
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
              <img
                alt="Transistor"
                src="/images/logo-cloud/transistor.svg"
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
              <img
                alt="Statamic"
                src="/images/logo-cloud/statamic.svg"
                class="h-9 max-sm:mx-auto sm:h-8 lg:h-12"
              />
            </div>
          </div>
        </div>
        <div class="bg-gradient-to-b from-white from-50% to-gray-100 py-32">
          <div class="overflow-hidden">
            <div class="pb-24 px-6 lg:px-8">
              <div class="mx-auto max-w-2xl lg:max-w-7xl">
                <h2 class="max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-gray-950 sm:text-6xl">
                  <%= gettext("Deploy, Observe, Distribute with a single dashboard.") %>
                </h2>
                <div class="mt-16 h-[36rem] sm:h-auto w-[76rem] sm:w-[76rem] relative aspect-[var(--width)/var(--height)] [--radius:theme(borderRadius.xl)]">
                  <div class="absolute -inset-[var(--padding)] rounded-[calc(var(--radius)+var(--padding))] shadow-sm ring-1 ring-black/5 [--padding:theme(spacing.2)]">
                  </div>
                  <img
                    src={~p"/images/landing-preview.png"}
                    class="h-full rounded-[var(--radius)] shadow-2xl ring-1 ring-black/10"
                  />
                </div>
              </div>
            </div>
          </div>
          <div class="px-6 lg:px-8">
            <div class="mx-auto max-w-2xl lg:max-w-7xl">
              <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500">
                <%= gettext("Dev Sec Ops") %>
              </h2>
              <h3 class="mt-2 max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
                <%= gettext("All-in-one distribution platform") %>
              </h3>
              <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6 lg:grid-rows-2">
                <div class="max-lg:rounded-t-4xl lg:col-span-3 lg:rounded-tl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
                  <div class="relative h-80 shrink-0">
                    <div class="h-80 bg-[url(/images/screenshots/infrastructure.png)] bg-[size:978px_345px] bg-[left_-8px_top_-12px] bg-no-repeat">
                    </div>
                    <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]">
                    </div>
                  </div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                      <%= gettext("Infrastructure") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
                      <%= gettext("Setup your infrastructure") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
                      <%= gettext(
                        "Configure your infrastructure. Opsmaru generates all the code you need to setup your infrastructure from scratch."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="lg:col-span-3 lg:rounded-tr-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
                  <div class="relative h-80 shrink-0">
                    <div class="absolute inset-0 bg-[url(/images/screenshots/build-configuration.png)] bg-[size:1100px_647px] bg-[left_-12px_top_-15px] bg-no-repeat">
                    </div>
                    <div class="absolute inset-0 bg-gradient-to-t from-white to-50% group-data-[dark]:from-gray-800 group-data-[dark]:from-[-25%]">
                    </div>
                  </div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                      <%= gettext("Deploy") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
                      <%= gettext("Build and deploy") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
                      <%= gettext(
                        "Connect your source code and deploy your application. Opsmaru helps configure your application and make it ready for deployment."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="lg:col-span-2 lg:rounded-bl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
                  <div class="relative h-80 shrink-0">
                    <div class="flex size-full pl-10 pt-10">
                      <div class="flex flex-col gap-2"></div>
                    </div>
                  </div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                      <%= gettext("Observe") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
                      <%= gettext("See what's happening") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
                      <%= gettext(
                        "Once your infrastructure is up and running you can see everything that's happening."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="lg:col-span-2 group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
                  <div class="relative h-80 shrink-0">
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
                      <%= gettext(
                        "Opsmaru supports a variety of languages and frameworks out of the box."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="max-lg:rounded-b-4xl lg:col-span-2 lg:rounded-br-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 data-[dark]:bg-gray-800 data-[dark]:ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                      <%= gettext("Setup a store") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 group-data-[dark]:text-white">
                      <%= gettext("Sell your apps to anyone") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 group-data-[dark]:text-gray-400">
                      <%= gettext(
                        "Opsmaru gives you all the tool to sell your web applications. Collect payments via stripe."
                      ) %>
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="mx-2 mt-2 rounded-4xl bg-slate-900 py-32">
          <div class="px-6 lg:px-8">
            <div class="mx-auto max-w-2xl lg:max-w-7xl">
              <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 dark:text-slate-400">
                <%= gettext("First class Day 2 Ops") %>
              </h2>
              <h3 class="mt-2 max-w-3xl text-pretty text-4xl font-medium tracking-tighter text-gray-950 dark:text-white sm:text-6xl">
                <%= gettext("Monitor and observe your infrastructure and applications.") %>
              </h3>
              <div class="mt-10 grid grid-cols-1 gap-4 sm:mt-16 lg:grid-cols-6 lg:grid-rows-2">
                <div class="max-lg:rounded-t-4xl lg:col-span-4 lg:rounded-tl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 dark:bg-slate-800 dark:ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10"></div>
                </div>
                <div class="z-10 lg:col-span-2 lg:rounded-tr-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 dark:bg-slate-800 dark:ring-white/15">
                  <div class="relative h-80 shrink-0"></div>
                  <div class="relative p-10"></div>
                </div>
                <div class="lg:col-span-2 lg:rounded-bl-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 dark:bg-slate-800 dark:ring-white/15">
                  <div
                    id="broadcast-graphics"
                    class="relative h-80 shrink-0"
                    phx-hook="MountBroadcast"
                  >
                  </div>
                  <div class="relative p-10">
                    <h3 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 dark:text-slate-400">
                      <%= gettext("Broadcasted Upgrade") %>
                    </h3>
                    <p class="mt-1 text-2xl/8 font-medium tracking-tight text-gray-950 dark:text-white">
                      <%= gettext("Push updates to your buyers") %>
                    </p>
                    <p class="mt-2 max-w-[600px] text-sm/6 text-gray-600 dark:text-slate-400">
                      <%= gettext(
                        "Opsmaru handles upgrades to multiple installations of your applications seamlessly."
                      ) %>
                    </p>
                  </div>
                </div>
                <div class="max-lg:rounded-b-4xl lg:col-span-4 lg:rounded-br-4xl group relative flex flex-col overflow-hidden rounded-lg bg-white shadow-sm ring-1 ring-black/5 dark:bg-slate-800 dark:ring-white/15">
                </div>
              </div>
            </div>
          </div>
        </div>
      </main>
      <div class="overflow-hidden py-32">
        <div class="px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <div>
              <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                <%= gettext("Latest updates") %>
              </h2>
              <h3 class="mt-2 text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
                <%= gettext("See what's new with Opsmaru.") %>
              </h3>
            </div>
          </div>
        </div>
        <div id="latest-updates-slider" phx-hook="MountSlider"></div>
      </div>
      <BaseComponents.footer />
    </div>
    """
  end
end
