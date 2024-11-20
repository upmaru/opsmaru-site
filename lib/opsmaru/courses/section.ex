defmodule Opsmaru.Courses.Section do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Courses.Chapter

  embedded_schema do
    field :index, :integer

    embeds_one :chapter, Chapter
  end

  def changeset(section, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    section
    |> cast(params, ~w(id index)a)
    |> validate_required(~w(id index)a)
    |> cast_embed(:chapter)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
