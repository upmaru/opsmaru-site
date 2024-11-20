defmodule Opsmaru.Courses do
  alias __MODULE__.Category

  defdelegate list_categories(options \\ []),
    to: Category.Manager,
    as: :list

  alias __MODULE__.Section

  defdelegate list_sections(options),
    to: Section.Manager,
    as: :list
end
