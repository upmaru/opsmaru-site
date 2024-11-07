defmodule Opsmaru.Content.Feature do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Product

  @valid_attrs ~w(id remark description active)a

  embedded_schema do
    embeds_one :product, Product

    embeds_one :category, Category do
      field :name, :string
    end

    field :description, :string
    field :remark, :string
    field :active, :boolean
  end

  def changeset(feature, params) do
    %{"_id" => id, "feature" => %{"description" => description}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("description", description)

    feature
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
    |> cast_embed(:category)
    |> cast_embed(:product)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
