defmodule Opsmaru.Features do
  alias __MODULE__.Category

  defdelegate list_categories(options \\ [cache: true]),
    to: Category.Manager,
    as: :list
end
