defmodule Opsmaru.Content.Technology do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image
  alias Opsmaru.Technologies.Category

  @derive Jason.Encoder
  embedded_schema do
    field :title, :string
    field :slug, :string
    field :type, :string

    embeds_one :logo, Image

    embeds_one :category, Category
  end

  def changeset(technology, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    technology
    |> cast(params, [:id, :title, :slug, :type])
    |> cast_embed(:logo)
    |> cast_embed(:category)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
