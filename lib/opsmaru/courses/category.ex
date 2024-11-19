defmodule Opsmaru.Courses.Category do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Course

  embedded_schema do
    field :name, :string
    field :slug, :string

    field :index, :integer

    embeds_many :courses, Course
  end

  def changeset(category, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    category
    |> cast(params, ~w(id name slug index)a)
    |> validate_required(~w(id name slug index)a)
    |> cast_embed(:courses)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
