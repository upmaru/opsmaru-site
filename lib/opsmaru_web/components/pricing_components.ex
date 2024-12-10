defmodule OpsmaruWeb.PricingComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Products
  alias Opsmaru.Content
  alias Opsmaru.Pages
  alias Opsmaru.Commerce

  alias OpsmaruWeb.BaseComponents

  use Gettext, backend: OpsmaruWeb.Gettext

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
    <div class="price -m-2 grid grid-cols-1 rounded-4xl shadow-[inset_0_0_2px_1px_#ffffff4d] ring-1 ring-black/5 max-lg:mx-auto max-lg:w-full max-lg:max-w-md">
      <div class="grid grid-cols-1 rounded-4xl p-2 shadow-md shadow-black/5">
        <div class="rounded-3xl bg-white p-10 pb-9 shadow-2xl ring-1 ring-black/5">
          <h2 class="font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
            {@price.product.name}
          </h2>
          <p class="mt-2 text-sm/6 text-slate-950/75">{@price.product.description}</p>
          <div class="mt-8 flex items-center gap-4">
            <div class="text-5xl font-medium text-slate-950">
              {Money.to_string(@money, fractional_unit: false)}
            </div>
            <div class="text-sm/5 text-slate-950/75">
              <p>{String.upcase(@price.currency)}</p>
              <%= if @metadata.user_count_limit > 1 do %>
                <p>
                  {gettext("per %{unit_label} per %{interval}",
                    unit_label: @price.product.unit_label,
                    interval: @price.recurring.interval
                  )}
                </p>
              <% else %>
                <p>
                  {gettext("per %{interval}", interval: @price.recurring.interval)}
                </p>
              <% end %>
            </div>
          </div>
          <div class="mt-8">
            <BaseComponents.button href="/auth/users/register">
              {gettext("Get started")}
            </BaseComponents.button>
          </div>
          <div class="mt-8">
            <h3 class="text-sm/6 font-medium text-slate-950">{gettext("What's included:")}</h3>
            <ul class="mt-3 space-y-3">
              <li
                :for={feature <- @features}
                class="flex items-start gap-4 text-sm/6 text-slate-950/75 data-[disabled]:text-slate-950/25"
              >
                <span class="inline-flex h-6 items-center">
                  <.icon name="hero-plus" class="shrink-0 text-slate-950/25" />
                </span>
                {feature.name}
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :section, Pages.Section, required: true
  attr :faqs, :list, required: true

  def faq(assigns) do
    h2 = match_content(assigns.section.contents, "pricing-faq-h2")
    title = match_content(assigns.section.contents, "pricing-faq-title")

    assigns =
      assigns
      |> assign(:h2, h2)
      |> assign(:title, title)

    ~H"""
    <section id="pricing-faq" class="scroll-mt-8">
      <h2 class="text-center font-mono text-xs/5 font-semibold uppercase tracking-widest text-slate-500 data-[dark]:text-slate-400">
        {@h2.body}
      </h2>
      <div class="mt-2 text-center text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
        {@title.body}
      </div>
      <div class="mx-auto mb-32 mt-16 max-w-xl space-y-12">
        <dl :for={faq <- @faqs}>
          <dt class="text-sm font-semibold">{faq.question}</dt>
          <dd class="mt-4 text-sm/6 text-slate-600 prose prose-a:text-cyan-500">
            {raw(MDEx.to_html!(faq.answer))}
          </dd>
        </dl>
      </div>
    </section>
    """
  end

  attr :products, :list, required: true
  attr :features, :list, required: true
  attr :product_features, :list, required: true

  def matrix(assigns) do
    ~H"""
    <tr :for={feature <- @features} class="border-b border-gray-100 last:border-none">
      <th class="px-0 py-4 text-sm/6 font-normal text-gray-600">
        {feature.description}
      </th>
      <.display
        :for={product <- @products}
        feature={feature}
        product_feature={match_product_feature(@product_features, product, feature)}
      />
    </tr>
    """
  end

  attr :feature, Content.Feature, required: true
  attr :product_feature, Products.Feature, default: nil

  def display(assigns) do
    ~H"""
    <td class="p-4 data-[selected]:table-cell max-sm:hidden">
      <div :if={@feature.display == "remark" && @product_feature} class="text-sm/6">
        {@product_feature.remark}
      </div>
      <div :if={@feature.display == "active" && @product_feature} class="text-sm/6">
        <.icon :if={@product_feature.active} name="hero-check" class="h-4 w-4 text-green-600" />
        <.icon :if={not @product_feature.active} name="hero-minus" class="h-4 w-4 text-slate-600" />
      </div>
    </td>
    """
  end

  defp match_product_feature(product_features, product, feature) do
    Enum.find(product_features, fn product_feature ->
      product_feature.product_id == product.id and product_feature.feature_id == feature.id
    end)
  end

  defp match_content(contents, slug) do
    Enum.find(contents, fn content ->
      content.slug == slug
    end)
  end
end
