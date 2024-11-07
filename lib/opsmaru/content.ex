defmodule Opsmaru.Content do
  alias __MODULE__.Post

  defdelegate list_posts,
    to: Post.Manager,
    as: :list

  defdelegate show_post(slug),
    to: Post.Manager,
    as: :show

  alias __MODULE__.Product

  defdelegate list_products,
    to: Product.Manager,
    as: :list

  alias __MODULE__.Feature

  defdelegate list_features,
    to: Feature.Manager,
    as: :list
end
