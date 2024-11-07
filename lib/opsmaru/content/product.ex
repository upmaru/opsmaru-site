defmodule Opsmaru.Content.Product do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(id index reference name)a

  embedded_schema do
    field :index, :integer
    field :reference, :string
    field :name, :string
    field :stripe_product, :map
  end

  def changeset(product, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    product
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
