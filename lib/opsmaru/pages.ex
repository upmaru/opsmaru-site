defmodule Opsmaru.Pages do
  alias __MODULE__.FAQ

  defdelegate list_faqs(page, options \\ []),
    to: FAQ.Manager,
    as: :list
end
