defmodule Opsmaru.Courses do
  alias __MODULE__.Category

  defdelegate list_categories(options \\ []),
    to: Category.Manager,
    as: :list

  alias __MODULE__.Section

  defdelegate list_sections(options),
    to: Section.Manager,
    as: :list

  alias __MODULE__.Episode

  defdelegate show_episode(course_slug, episode_slug, options \\ []),
    to: Episode.Manager,
    as: :show
end
