defmodule Opsmaru.Features.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Feature

  embedded_schema do
    field :index, :integer
    field :name, :string

    embeds_many :features, Feature
  end

  def changeset(category, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    category
    |> cast(params, ~w(id index name)a)
    |> cast_embed(:features)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
