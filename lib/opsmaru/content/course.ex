defmodule Opsmaru.Content.Course do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Author
  alias Opsmaru.Content.Technology
  alias Opsmaru.Content.Video

  embedded_schema do
    field :title, :string
    field :slug, :string

    field :description, :string
    field :overview, :string

    embeds_one :introduction, Video

    embeds_one :author, Author

    embeds_one :main_technology, Technology
  end

  def changeset(course, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    course
    |> cast(params, ~w(id title slug description overview)a)
    |> validate_required(~w(id title slug overview)a)
    |> cast_embed(:author)
    |> cast_embed(:main_technology)
    |> cast_embed(:introduction)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
