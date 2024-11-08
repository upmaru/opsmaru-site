defmodule Opsmaru.Products do
  alias __MODULE__.Feature

  defdelegate list_features(options \\ []),
    to: Feature.Manager,
    as: :list
end
