defmodule Opsmaru.Content.Logo do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :image, :string
    field :name, :string
  end

  def changeset(logo, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    logo
    |> cast(params, ~w(id image name)a)
    |> validate_required(~w(id image name)a)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
