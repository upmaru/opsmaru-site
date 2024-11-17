defmodule Opsmaru.Pages.Section do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Pages.Content
  alias Opsmaru.Pages.Card

  embedded_schema do
    field :title, :string
    field :slug, :string

    embeds_many :contents, Content
    embeds_many :cards, Card
  end

  def changeset(section, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    section
    |> cast(params, ~w(id title slug)a)
    |> validate_required(~w(id title slug)a)
    |> cast_embed(:contents)
    |> cast_embed(:cards)
  end
end
