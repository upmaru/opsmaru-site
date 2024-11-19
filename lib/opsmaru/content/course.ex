defmodule Opsmaru.Content.Course do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image
  alias Opsmaru.Content.Technology

  embedded_schema do
    field :title, :string
    field :slug, :string

    field :description, :string

    embeds_one :cover, Image

    embeds_one :main_technology, Technology
  end

  def changeset(course, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    course
    |> cast(params, ~w(id title slug description)a)
    |> validate_required(~w(id title slug)a)
    |> cast_embed(:cover)
    |> cast_embed(:main_technology)
  end
end
