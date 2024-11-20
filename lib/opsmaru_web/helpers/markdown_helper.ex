defmodule OpsmaruWeb.MarkdownHelper do
  use Phoenix.Component
  import Phoenix.HTML
  use Gettext, backend: OpsmaruWeb.Gettext

  def render_markdown(content) do
    opts = [
      extension: [autolink: true],
      render: [unsafe_: true],
      features: [syntax_highlight_theme: "tokyonight_moon"]
    ]

    content
    |> MDEx.parse_document!(opts)
    |> MDEx.traverse_and_update(fn
      # inject a html block to render a note alert
      {"block_quote", %{}, [{"paragraph", %{}, ["[!NOTE]" | rest]}]} ->
        alert_block(rest, :note, opts)

      {"block_quote", %{}, [{"paragraph", %{}, ["[!NOTE]"]} | rest]} ->
        alert_block(rest, :note, opts)

      # inject a html block to render a caution alert
      {"block_quote", %{}, [{"paragraph", %{}, ["[!CAUTION]" | rest]}]} ->
        alert_block(rest, :caution, opts)

      {"block_quote", %{}, [{"paragraph", %{}, ["[!CAUTION]"]} | rest]} ->
        alert_block(rest, :caution, opts)

      {"block_quote", %{}, [{"paragraph", %{}, ["[!OBJECTIVES]"]} | rest]} ->
        objectives_block(rest, opts)

      node ->
        node
    end)
    |> MDEx.to_html!(opts)
  end

  defp alert_block(content, type, opts) do
    {top, rest} = List.pop_at(content, 0)

    heading =
      case top do
        {"heading", _, [heading]} -> heading
        _ -> nil
      end

    content =
      if heading do
        MDEx.to_html!(rest, opts)
      else
        MDEx.to_html!(content, opts)
      end

    alert =
      alert(%{type: type, heading: heading, content: content})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    {"html_block", %{"literal" => alert}, []}
  end

  defp objectives_block(content,  opts) do
    {top, rest} = List.pop_at(content, 0)

    heading =
      case top do
        {"heading", _, [heading]} -> heading
        _ -> nil
      end

    content =
      if heading do
        MDEx.to_html!(rest, opts)
      else
        MDEx.to_html!(content, opts)
      end

    list =
      objectives_list(%{heading: heading, content: content})
      |> Phoenix.HTML.Safe.to_iodata()
      |> IO.iodata_to_binary()

    {"html_block", %{"literal" => list}, []}
  end

  attr :type, :atom, default: :note
  attr :heading, :string, default: nil
  attr :content, :string, required: true

  defp alert(%{type: :note} = assigns) do
    ~H"""
    <div class="rounded-md bg-blue-50 p-4">
      <div class="flex">
        <div class="shrink-0">
          <svg
            class="h-5 w-5 text-blue-400"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
            data-slot="icon"
          >
            <path
              fill-rule="evenodd"
              d="M18 10a8 8 0 1 1-16 0 8 8 0 0 1 16 0Zm-7-4a1 1 0 1 1-2 0 1 1 0 0 1 2 0ZM9 9a.75.75 0 0 0 0 1.5h.253a.25.25 0 0 1 .244.304l-.459 2.066A1.75 1.75 0 0 0 10.747 15H11a.75.75 0 0 0 0-1.5h-.253a.25.25 0 0 1-.244-.304l.459-2.066A1.75 1.75 0 0 0 9.253 9H9Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="ml-3">
          <h5 class="text-sm font-medium text-blue-800"><%= @heading || gettext("Notice") %></h5>
          <div class="mt-2 text-sm text-blue-700">
            <%= raw(@content) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp alert(%{type: :caution} = assigns) do
    ~H"""
    <div class="rounded-md bg-amber-50 p-4">
      <div class="flex">
        <div class="shrink-0">
          <svg
            class="h-5 w-5 text-amber-400"
            viewBox="0 0 20 20"
            fill="currentColor"
            aria-hidden="true"
            data-slot="icon"
          >
            <path
              fill-rule="evenodd"
              d="M8.485 2.495c.673-1.167 2.357-1.167 3.03 0l6.28 10.875c.673 1.167-.17 2.625-1.516 2.625H3.72c-1.347 0-2.189-1.458-1.515-2.625L8.485 2.495ZM10 5a.75.75 0 0 1 .75.75v3.5a.75.75 0 0 1-1.5 0v-3.5A.75.75 0 0 1 10 5Zm0 9a1 1 0 1 0 0-2 1 1 0 0 0 0 2Z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="ml-3">
          <h5 class="text-sm font-medium text-amber-800"><%= @heading || gettext("Warning") %></h5>
          <div class="mt-2 text-sm text-amber-700">
            <%= raw(@content) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp objectives_list(assigns) do
    ~H"""
    <div>
      <hr />
      <div>
        <div class="px-4 pt-5 not-prose">
          <h3 class="text-xl font-semibold text-slate-900"><%= @heading %></h3>
        </div>
        <div class="px-4 pb-5">
          <div class="objectives-list mt-2 max-w-xl text-md text-slate-500">
            <%= raw(@content) %>
          </div>
        </div>
      </div>
      <hr />
    </div>
    """
  end
end
