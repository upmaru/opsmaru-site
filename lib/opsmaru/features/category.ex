defmodule Opsmaru.Features.Category do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string

    embeds_many :features, Feature do
      field :description, :string
    end
  end

  def changeset(category, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    category
    |> cast(params, ~w(id name)a)
    |> cast_embed(:features, with: &feature_changeset/2)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end

  defp feature_changeset(feature, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    feature
    |> cast(params, ~w(id description)a)
    |> validate_required(~w(id description)a)
  end
end
