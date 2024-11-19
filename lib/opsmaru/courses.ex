defmodule Opsmaru.Courses do
  alias __MODULE__.Category

  defdelegate list_categories(options \\ []),
    to: Category.Manager,
    as: :list
end
