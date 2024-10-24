defmodule OpsmaruWeb.BaseComponents do
  use Phoenix.Component

  attr :href, :string, required: true
  attr :variant, :atom, default: :primary
  slot :inner_block, required: true

  def link(%{variant: :primary} = assigns) do
    ~H"""
    <a
      href={@href}
      class={[
        "inline-flex items-center justify-center px-4 py-[calc(theme(spacing.2)-1px)]",
        "rounded-full border border-transparent bg-gray-950 shadow-md",
        "whitespace-nowrap text-base font-medium text-white",
        "data-[disabled]:bg-gray-950 data-[hover]:bg-gray-800 data-[disabled]:opacity-40"
      ]}
    >
      <%= render_slot(@inner_block) %>
    </a>
    """
  end

  def link(%{variant: :secondary} = assigns) do
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
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="hidden group-last/row:group-first/item:block absolute size-[15px] fill-black/10 -bottom-2 -left-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <svg
        viewBox="0 0 15 15"
        aria-hidden="true"
        class="hidden group-last/row:block absolute size-[15px] fill-black/10 -bottom-2 -right-2"
      >
        <path d="M8 0H7V7H0V8H7V15H8V8H15V7H8V0Z"></path>
      </svg>
      <%= render_slot(@inner_block) %>
    </div>
    """
  end
end
