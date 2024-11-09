defmodule OpsmaruWeb.PricingLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Pages
  alias Opsmaru.Features
  alias Opsmaru.Products

  alias OpsmaruWeb.PricingComponents

  import __MODULE__.DataLoader

  def mount(_params, _session, socket) do
    prices = load_prices()
    page = Content.show_page("pricing")
    faqs = Pages.list_faqs(page)
    products = Content.list_products()
    categories = Features.list_categories()
    product_features = Products.list_features()

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:prices, prices)
      |> assign(:page, page)
      |> assign(:faqs, faqs)
      |> assign(:products, products)
      |> assign(:categories, categories)
      |> assign(:product_features, product_features)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <div class="mt-16 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h1 class="text-pretty text-4xl font-medium tracking-tighter text-slate-950 data-[dark]:text-white sm:text-6xl">
            <%= gettext("You'll find we're very generous.") %>
          </h1>
          <p class="mt-6 max-w-3xl text-2xl font-medium text-slate-500">
            <%= gettext(
              "Launch with a plan that makes the most sense, grow and adjust as you need. Our pricing goes from costing nothing to an all you can eat model."
            ) %>
          </p>
        </div>
      </div>
      <div class="relative py-24">
        <div class="absolute inset-x-2 bottom-0 top-48 rounded-4xl ring-1 ring-inset ring-slate-950/5 bg-[linear-gradient(115deg,var(--tw-gradient-stops))] from-cyan-300 from-[28%] via-purple-400 via-[70%] to-violet-600 sm:bg-[linear-gradient(145deg,var(--tw-gradient-stops))]">
        </div>
        <div class="relative px-6 lg:px-8">
          <div class="mx-auto max-w-2xl lg:max-w-7xl">
            <div class="grid grid-cols-1 gap-8 lg:grid-cols-3">
              <BaseComponents.price :for={price <- @prices} price={price} />
            </div>
            <div class="mt-24 flex justify-between max-sm:mx-auto max-sm:max-w-md max-sm:flex-wrap max-sm:justify-evenly max-sm:gap-x-4 max-sm:gap-y-4">
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
      </div>
      <div class="py-24 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <table class="w-full text-left">
            <caption class="sr-only"><%= gettext("Pricing plan comparison") %></caption>
            <colgroup>
              <col class="w-3/5 sm:w-2/5" />
              <col class="w-2/5 data-[selected]:table-column max-sm:hidden sm:w-1/5" />
              <col class="w-2/5 data-[selected]:table-column max-sm:hidden sm:w-1/5" />
              <col class="w-2/5 data-[selected]:table-column max-sm:hidden sm:w-1/5" />
            </colgroup>
            <thead>
              <tr class="max-sm:hidden">
                <td class="p-0"></td>
                <th :for={product <- @products} class="p-0 data-[selected]:table-cell max-sm:hidden">
                  <div class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
                    <%= product.name %>
                  </div>
                </th>
              </tr>
              <tr class="sm:hidden">
                <td class="p-0">
                  <div class="relative inline-block"></div>
                </td>
                <td class="p-0 text-right">
                  <a
                    href="#"
                    class="inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
                  >
                    <%= gettext("Get started") %>
                  </a>
                </td>
              </tr>
              <tr class="max-sm:hidden">
                <th class="p-0" scope="row">
                  <span class="sr-only"><%= gettext("Get started") %></span>
                </th>
                <td
                  :for={product <- @products}
                  class="px-0 pb-0 pt-4 data-[selected]:table-cell max-sm:hidden"
                >
                  <a
                    href="#"
                    class="inline-flex items-center justify-center px-2 py-[calc(theme(spacing.[1.5])-1px)] rounded-lg border border-transparent shadow ring-1 ring-black/10 whitespace-nowrap text-sm font-medium text-gray-950 data-[disabled]:bg-transparent data-[hover]:bg-gray-50 data-[disabled]:opacity-40"
                  >
                    <%= gettext("Get started") %>
                  </a>
                </td>
              </tr>
            </thead>
            <tbody :for={category <- @categories} class="group">
              <tr>
                <th class="px-0 pb-0 pt-10 group-first-of-type:pt-5" colspan="4">
                  <div class="-mx-4 rounded-lg bg-gray-50 px-4 py-3 text-sm/6 font-semibold">
                    <%= category.name %>
                  </div>
                </th>
              </tr>
              <PricingComponents.matrix
                products={@products}
                features={category.features}
                product_features={@product_features}
              />
            </tbody>
          </table>
        </div>
      </div>
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <PricingComponents.faq
            section={Enum.find(@page.sections, &(&1.slug == "pricing-faq"))}
            faqs={@faqs}
          />
        </div>
      </div>
    </div>
    """
  end
end
