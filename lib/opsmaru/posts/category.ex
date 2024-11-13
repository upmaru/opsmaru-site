defmodule Opsmaru.Posts.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :name, :string
    field :slug, :string
  end

  def changeset(category, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    category
    |> cast(params, ~w(id name slug)a)
    |> validate_required(~w(id name slug)a)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
