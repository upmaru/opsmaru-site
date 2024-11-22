defmodule Opsmaru.Courses.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Courses.Episode

  embedded_schema do
    field :title, :string

    embeds_many :episodes, Episode
  end

  def changeset(chapter, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    chapter
    |> cast(params, ~w(id title)a)
    |> validate_required(~w(id title)a)
    |> cast_embed(:episodes)
  end
end
