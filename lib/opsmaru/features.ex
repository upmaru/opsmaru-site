defmodule Opsmaru.Features do
  alias __MODULE__.Category

  defdelegate list_categories(options \\ []),
    to: Category.Manager,
    as: :list
end
