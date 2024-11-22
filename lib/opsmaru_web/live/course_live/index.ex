defmodule OpsmaruWeb.CourseLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Courses

  alias OpsmaruWeb.CourseComponents

  @page_slug "learn"

  def mount(_params, _session, socket) do
    page = Content.show_page(@page_slug)

    header_section = Enum.find(page.sections, &(&1.slug == "learn-header"))

    categories = Courses.list_categories()
    technologies = Content.list_technologies(end_index: 12)

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:categories, categories)
      |> assign(:technologies, technologies)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <CourseComponents.header section={@header_section} />
      <CourseComponents.categories categories={@categories} />
      <CourseComponents.technologies technologies={@technologies} />
    </div>
    """
  end
end
