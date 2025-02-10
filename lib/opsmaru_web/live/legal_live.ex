defmodule OpsmaruWeb.LegalLive do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Content.Image

  import OpsmaruWeb.MarkdownHelper

  defmodule LegalNotFound do
    defexception message: "Legal page not found", plug_status: 404
  end

  @impl true
  def mount(%{"id" => slug}, _session, socket) do
    with %{data: %Content.Page{} = page} <- Content.show_page(slug) do
      main_section =
        Enum.find(page.sections, &(&1.slug == "#{slug}-main"))

      main_content =
        Enum.find(main_section.contents, &(&1.slug == "#{slug}-main-content"))

      page_cover = Map.get(page, :cover) || %Image{}

      socket =
        socket
        |> assign(:page_title, page.title)
        |> assign(:page_description, page.description)
        |> assign(:page_cover_url, page_cover.url)
        |> assign(:page, page)
        |> assign(:main_section, main_section)
        |> assign(:main_content, main_content)

      {:ok, socket}
    else
      _ -> raise LegalNotFound
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <div class="mt-16 px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <h2 class="mt-16 font-mono text-xs/5 font-semibold uppercase tracking-widest text-gray-500 data-[dark]:text-gray-400">
            {Calendar.strftime(@main_content.published_at, "%a, %B %d, %Y")}
          </h2>
          <h1 class="text-pretty text-4xl font-medium tracking-tighter text-slate-950 data-[dark]:text-white sm:text-6xl">
            {@main_section.title}
          </h1>
          <p class="mt-6 max-w-3xl text-2xl font-medium text-slate-500">
            {gettext(
              "Please read the following before using our product. By using our product you agree to these terms and conditions."
            )}
          </p>
        </div>
      </div>
      <div class="px-6 lg:px-8">
        <div class="mx-auto max-w-2xl lg:max-w-7xl">
          <div class="mt-16 mb-32">
            <div class="max-w-2xl xl:mx-auto">
              <div class="prose prose-slate prose-img:rounded-2xl prose-h2:font-medium lg:prose-lg">
                {raw(render_markdown(@main_content.markdown))}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_params(_params, url, socket) do
    {:noreply, assign(socket, :canonical_url, url)}
  end
end
