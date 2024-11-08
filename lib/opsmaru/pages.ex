defmodule Opsmaru.Pages do
  alias __MODULE__.FAQ

  defdelegate list_faqs(page),
    to: FAQ.Manager,
    as: :list
end
