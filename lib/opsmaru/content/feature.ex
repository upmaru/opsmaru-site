defmodule Opsmaru.Content.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(id description display)a

  embedded_schema do
    field :description, :string
    field :display, :string
  end

  def changeset(feature, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    feature
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
