defmodule OpsmaruWeb.BaseComponents do
  use Phoenix.Component
  use OpsmaruWeb, :verified_routes

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
end
