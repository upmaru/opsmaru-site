defmodule Opsmaru.Content.Author do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image

  embedded_schema do
    field :name, :string
    field :title, :string

    field :bio, :string

    embeds_one :avatar, Image
  end

  def changeset(author, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    author
    |> cast(params, ~w(id name title bio)a)
    |> validate_required(~w(id name title)a)
    |> cast_embed(:avatar)
  end
end
