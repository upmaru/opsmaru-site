defmodule OpsmaruWeb.PricingComponents do
  use OpsmaruWeb, :html

  alias Opsmaru.Products
  alias Opsmaru.Content
  alias Opsmaru.Pages

  use Gettext, backend: OpsmaruWeb.Gettext

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
        <%= @h2.body %>
      </h2>
      <div class="mt-2 text-center text-pretty text-4xl font-medium tracking-tighter text-gray-950 data-[dark]:text-white sm:text-6xl">
        <%= @title.body %>
      </div>
      <div class="mx-auto mb-32 mt-16 max-w-xl space-y-12">
        <dl :for={faq <- @faqs}>
          <dt class="text-sm font-semibold"><%= faq.question %></dt>
          <dd class="mt-4 text-sm/6 text-slate-600 prose prose-a:text-cyan-500">
            <%= raw(MDEx.to_html!(faq.answer)) %>
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
        <%= feature.description %>
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
        <%= @product_feature.remark %>
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
