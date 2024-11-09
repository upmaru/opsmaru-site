defmodule Opsmaru.Pages.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(id slug image heading title description)a

  embedded_schema do
    field :slug, :string
    field :image, :string
    field :heading, :string
    field :title, :string
    field :description, :string
  end

  def changeset(card, params) do
    %{"_id" => id, "card" => card_params} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", card_params["slug"]["current"])

    card
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
  end
end
