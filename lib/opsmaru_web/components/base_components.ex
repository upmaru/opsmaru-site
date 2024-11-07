defmodule OpsmaruWeb.BaseComponents do
  use Phoenix.Component
  use OpsmaruWeb, :verified_routes

  alias Opsmaru.Commerce

  alias OpsmaruWeb.CoreComponents

  use Gettext, backend: OpsmaruWeb.Gettext

  def header(assigns) do
    ~H"""
    <header class="pt-12 sm:pt-16">
      <div>
        <div class="relative flex justify-between group/row isolate pt-[calc(theme(spacing.2)+1px)] last:pb-[calc(theme(spacing.2)+1px)]">
          <div class="absolute inset-y-0 left-1/2 -z-10 w-screen -translate-x-1/2">
            <div class="absolute inset-x-0 top-0 border-t border-black/5"></div>
            <div class="absolute inset-x-0 top-2 border-t border-black/5"></div>
            <div class="absolute inset-x-0 bottom-0 hidden border-b border-black/5 group-last/row:block">
            </div>
            <div class="absolute inset-x-0 bottom-2 hidden border-b border-black/5 group-last/row:block">
            </div>
          </div>
          <div class="relative flex gap-6">
            <.nav class="py-3 group/item relative">
              <.link navigate="/" class="space-x-3 flex">
                <img src={~p"/images/logo.svg"} alt="Opsmaru" class="h-9 overflow-visible" />
                <span class="font-medium text-xl mt-1"><%= gettext("Opsmaru") %></span>
              </.link>
            </.nav>
          </div>
          <nav class="relative hidden lg:flex">
            <.nav class="relative flex group/item">
              <.link
                navigate={~p"/our-product/pricing"}
                class="flex items-center px-4 py-3 text-base font-medium text-gray-950 bg-blend-multiply data-[hover]:bg-black/[2.5%]"
              >
                <%= gettext("Pricing") %>
              </.link>
            </.nav>
          </nav>
        </div>
      </div>
    </header>
    """
  end

  attr :href, :string, required: true
  attr :variant, :atom, default: :primary
  slot :inner_block, required: true

  def button(%{variant: :primary} = assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "inline-flex items-center justify-center px-4 py-[calc(theme(spacing.2)-1px)]",
        "rounded-full border border-transparent bg-slate-950 shadow-md",
        "whitespace-nowrap text-base font-medium text-white",
        "data-[disabled]:bg-slate-950 hover:bg-slate-800 data-[disabled]:opacity-40"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end

  def button(%{variant: :secondary} = assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "relative inline-flex items-center justify-center px-4 py-[calc(theme(spacing.2)-1px)]",
        "rounded-full border border-transparent bg-white/10 shadow-md ring-1 ring-slate/15",
        "after:absolute after:inset-0 after:rounded-full after:shadow-[inset_0_0_2px_1px_#ffffff4d]",
        "whitespace-nowrap text-base font-medium text-gray-950",
        "data-[disabled]:bg-white/15 data-[hover]:bg-white/20 data-[disabled]:opacity-40"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end

  attr :class, :string, default: ""
  slot :inner_block, required: true

  def nav(assigns) do
    ~H"""
    <div class={@class}>
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="hidden group-first/item:block absolute size-[15px] fill-slate-950/10 -top-2 -left-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="absolute size-[15px] fill-slate-950/10 -top-2 -right-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="hidden group-last/row:group-first/item:block absolute size-[15px] fill-slate-950/10 -bottom-2 -left-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="hidden group-last/row:block absolute size-[15px] fill-slate-950/10 -bottom-2 -right-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :price, Stripe.Price, required: true

  def price(assigns) do
    price = assigns.price

    metadata = Commerce.parse_metadata(price.product.metadata)

    assigns =
      assigns
      |> assign(:money, Money.new(price.unit_amount, price.currency))
      |> assign(:metadata, metadata)
      |> assign(:features, price.product.features)

    ~H"""
    <div class="-m-2 grid grid-cols-1 rounded-4xl shadow-[inset_0_0_2px_1px_#ffffff4d] ring-1 ring-black/5 max-lg:mx-auto max-lg:w-full max-lg:max-w-md">
      <div class="grid grid-cols-1 rounded-4xl p-2 shadow-md shadow-black/5">
        <div class="rounded-3xl bg-white p-10 pb-9 shadow-2xl ring-1 ring-black/5">
          <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
            <%= @price.product.name %>
          </h2>
          <p class="mt-2 text-sm/6 text-slate-950/75"><%= @price.product.description %></p>
          <div class="mt-8 flex items-center gap-4">
            <div class="text-5xl font-medium text-slate-950">
              <%= Money.to_string(@money, fractional_unit: false) %>
            </div>
            <div class="text-sm/5 text-slate-950/75">
              <p><%= String.upcase(@price.currency) %></p>
              <%= if @metadata.user_count_limit > 1 do %>
                <p>
                  <%= gettext("per seat per %{interval}", interval: @price.recurring.interval) %>
                </p>
              <% else %>
                <p>
                  <%= gettext("per %{interval}", interval: @price.recurring.interval) %>
                </p>
              <% end %>
            </div>
          </div>
          <div class="mt-8">
            <.button href="/auth/users/register">
              <%= gettext("Get started") %>
            </.button>
          </div>
          <div class="mt-8">
            <h3 class="text-sm/6 font-medium text-slate-950"><%= gettext("What's included:") %></h3>
            <ul class="mt-3 space-y-3">
              <li
                :for={feature <- @features}
                class="flex items-start gap-4 text-sm/6 text-slate-950/75 data-[disabled]:text-slate-950/25"
              >
                <span class="inline-flex h-6 items-center">
                  <CoreComponents.icon name="hero-plus" class="shrink-0 text-slate-950/25" />
                </span>
                <%= feature.name %>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def footer(assigns) do
    ~H"""
    <footer>
      <div class="relative bg-[linear-gradient(115deg,var(--tw-gradient-stops))] from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 sm:bg-[linear-gradient(145deg,var(--tw-gradient-stops))]">
        <div class="absolute inset-2 rounded-4xl bg-white/80"></div>
        <div class="px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <div class="relative pb-16 pt-20 text-center sm:py-24">
              <hgroup>
                <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500 dark:text-slate-400">
                  <%= gettext("Get started") %>
                </h2>
                <p class="mt-6 text-3xl font-medium tracking-tight text-gray-950 sm:text-5xl">
                  <%= gettext("Ready to deploy?") %>
                  <br />
                  <%= gettext("Start your free trial today.") %>
                </p>
              </hgroup>
              <p class="mx-auto mt-6 max-w-xs text-sm/6 text-slate-500">
                <%= gettext(
                  "Become a pioneer class customer and adopt a new way to monetize your web apps. Reach new customers and start a revolution with us."
                ) %>
              </p>
              <div class="mt-6">
                <.button href="/auth/users/log_in">
                  <%= gettext("Get started") %>
                </.button>
              </div>
            </div>
            <div class="pb-16">
              <div class="group/row relative isolate pt-[calc(theme(spacing.2)+1px)] last:pb-[calc(theme(spacing.2)+1px)]">
                <div class="absolute inset-y-0 left-1/2 -z-10 w-screen -translate-x-1/2">
                  <div class="absolute inset-x-0 top-0 border-t border-slate-950/5"></div>
                  <div class="absolute inset-x-0 top-2 border-t border-slate-950/5"></div>
                </div>
                <div class="grid grid-cols-2 gap-y-10 pb-6 lg:grid-cols-6 lg:gap-8">
                  <div class="col-span-2 flex">
                    <div class="pt-6 lg:pb-6 group/item relative">
                      <svg
                        viewBox="0 0 15 15"
                        aria-hidden="true"
                        class="hidden group-first/item:block absolute size-[15px] fill-black/10 -top-2 -left-2"
                      >
                        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                      </svg>
                      <svg
                        viewBox="0 0 15 15"
                        aria-hidden="true"
                        class="absolute size-[15px] fill-black/10 -top-2 -right-2"
                      >
                        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                      </svg>
                      <a href={~p"/"} class="space-x-3 flex">
                        <img src={~p"/images/logo.svg"} alt="Opsmaru" class="h-9 overflow-visible" />
                        <span class="font-medium text-xl mt-1"><%= gettext("Opsmaru") %></span>
                      </a>
                    </div>
                  </div>
                  <div class="col-span-2 grid grid-cols-2 gap-x-8 gap-y-12 lg:col-span-4 lg:grid-cols-subgrid lg:pt-6">
                    <div>
                      <h3 class="text-sm/6 font-medium text-slate-950/50">
                        <%= gettext("Product") %>
                      </h3>
                      <ul class="mt-6 space-y-4 text-sm/6">
                        <li>
                          <.link navigate={~p"/our-product/pricing"}>
                            <%= gettext("Pricing") %>
                          </.link>
                        </li>
                        <li>
                          <a href="/docs/">
                            <%= gettext("Documentation") %>
                          </a>
                        </li>
                      </ul>
                    </div>
                    <div>
                      <h3 class="text-sm/6 font-medium text-slate-950/50">
                        <%= gettext("Company") %>
                      </h3>
                      <ul class="mt-6 space-y-4 text-sm/6">
                        <li>
                          <.link navigate={~p"/blog"}>
                            <%= gettext("Blog") %>
                          </.link>
                        </li>
                      </ul>
                    </div>
                    <div>
                      <h3 class="text-sm/6 font-medium text-slate-950/50">
                        <%= gettext("Support") %>
                      </h3>
                      <ul class="mt-6 space-y-4 text-sm/6">
                        <li>
                          <a href="https://discord.gg/9ecvvKfBnp" target="_blank">
                            <%= gettext("Discord") %>
                          </a>
                        </li>
                      </ul>
                    </div>
                    <div>
                      <h3 class="text-sm/6 font-medium text-slate-950/50">
                        <%= gettext("Legal") %>
                      </h3>
                      <ul class="mt-6 space-y-4 text-sm/6">
                        <li>
                          <.link navigate={~p"/legal/privacy-policy"}>
                            <%= gettext("Privacy Policy") %>
                          </.link>
                        </li>
                        <li>
                          <.link navigate={~p"/legal/terms-of-service"}>
                            <%= gettext("Terms of Service") %>
                          </.link>
                        </li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
              <div class="flex justify-between group/row relative isolate pt-[calc(theme(spacing.2)+1px)] last:pb-[calc(theme(spacing.2)+1px)]">
                <div class="absolute inset-y-0 left-1/2 -z-10 w-screen -translate-x-1/2">
                  <div class="absolute inset-x-0 top-0 border-t border-slate-950/5"></div>
                  <div class="absolute inset-x-0 top-2 border-t border-slate-950/5"></div>
                  <div class="absolute inset-x-0 bottom-0 hidden border-b border-slate-950/5 group-last/row:block">
                  </div>
                  <div class="absolute inset-x-0 bottom-2 hidden border-b border-slate-950/5 group-last/row:block">
                  </div>
                </div>
                <div>
                  <div class="py-3 group/item relative">
                    <svg
                      viewBox="0 0 15 15"
                      aria-hidden="true"
                      class="hidden group-first/item:block absolute size-[15px] fill-slate-950/10 -top-2 -left-2"
                    >
                      <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                    </svg>
                    <svg
                      viewBox="0 0 15 15"
                      aria-hidden="true"
                      class="absolute size-[15px] fill-slate-950/10 -top-2 -right-2"
                    >
                      <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                    </svg>
                    <svg
                      viewBox="0 0 15 15"
                      aria-hidden="true"
                      class="hidden group-last/row:group-first/item:block absolute size-[15px] fill-slate-950/10 -bottom-2 -left-2"
                    >
                      <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                    </svg>
                    <svg
                      viewBox="0 0 15 15"
                      aria-hidden="true"
                      class="hidden group-last/row:block absolute size-[15px] fill-slate-950/10 -bottom-2 -right-2"
                    >
                      <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
                    </svg>
                    <div class="text-sm/6 text-gray-950">
                      © <!-- -->
                      <%= Date.utc_today().year %>
                      <!-- -->Upmaru, Inc.
                    </div>
                  </div>
                </div>
                <div class="flex"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
    """
  end
end
