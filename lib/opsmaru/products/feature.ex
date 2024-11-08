defmodule Opsmaru.Products.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(id product_id feature_id remark active)a
  @required_attrs ~w(id product_id feature_id active)a

  embedded_schema do
    field :product_id, :binary_id
    field :feature_id, :binary_id

    field :remark, :string
    field :active, :boolean
  end

  def changeset(feature, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    feature
    |> cast(params, @valid_attrs)
    |> validate_required(@required_attrs)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
