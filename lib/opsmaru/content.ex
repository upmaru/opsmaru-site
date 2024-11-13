defmodule Opsmaru.Content do
  alias __MODULE__.Logo

  defdelegate list_logos(options \\ []),
    to: Logo.Manager,
    as: :list

  alias __MODULE__.Navigation

  defdelegate list_nagivations(options \\ []),
    to: Navigation.Manager,
    as: :list

  alias __MODULE__.Post

  defdelegate list_posts(options \\ []),
    to: Post.Manager,
    as: :list

  defdelegate posts_count(options \\ []),
    to: Post.Manager,
    as: :count

  defdelegate featured_posts(options \\ []),
    to: Post.Manager,
    as: :featured

  defdelegate posts_feed,
    to: Post.Manager,
    as: :feed

  defdelegate show_post(slug),
    to: Post.Manager,
    as: :show

  alias __MODULE__.Product

  defdelegate list_products,
    to: Product.Manager,
    as: :list

  alias __MODULE__.Page

  defdelegate show_page(slug),
    to: Page.Manager,
    as: :show

  alias __MODULE__.Price

  defdelegate list_prices,
    to: Price.Manager,
    as: :list
end
