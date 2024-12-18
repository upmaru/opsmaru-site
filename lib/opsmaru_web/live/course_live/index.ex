defmodule OpsmaruWeb.CourseLive.Index do
  use OpsmaruWeb, :live_view

  alias Opsmaru.Content
  alias Opsmaru.Courses
  alias Opsmaru.Pages

  alias OpsmaruWeb.CourseComponents

  @page_slug "learn"

  def mount(_params, _session, %{assigns: assigns} = socket) do
    %{data: page} = Content.show_page(@page_slug, perspective: assigns.perspective)

    header_section = Enum.find(page.sections, &(&1.slug == "#{@page_slug}-header"))
    get_support_section = Enum.find(page.sections, &(&1.slug == "#{@page_slug}-get-support"))

    %{data: featured_categories} =
      Courses.list_categories(featured: true, perspective: assigns.perspective)

    %{data: technologies} =
      Content.list_technologies(end_index: 12, perspective: assigns.perspective)

    %{data: categories} =
      Courses.list_categories(featured: false, perspective: assigns.perspective)

    socket =
      socket
      |> assign(:page_title, page.title)
      |> assign(:page, page)
      |> assign(:header_section, header_section)
      |> assign(:get_support_section, get_support_section)
      |> assign(:featured_categories, featured_categories)
      |> assign(:technologies, technologies)
      |> assign(:categories, categories)

    {:ok, socket}
  end

  attr :header_section, Pages.Section, required: true
  attr :featured_categories, :list, required: true
  attr :technologies, :list, required: true

  def render(assigns) do
    ~H"""
    <div>
      <CourseComponents.header section={@header_section} />
      <CourseComponents.categories categories={@featured_categories} />
      <CourseComponents.technologies technologies={@technologies} />
      <CourseComponents.categories categories={@categories} />
      <CourseComponents.get_support section={@get_support_section} />
    </div>
    """
  end
end
