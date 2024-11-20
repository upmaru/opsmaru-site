defmodule Opsmaru.Content.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Video

  @derive Jason.Encoder

  embedded_schema do
    field :title, :string
    field :slug, :string

    embeds_one :video, Video
  end

  def changeset(movie, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    movie
    |> cast(params, ~w(id title slug)a)
    |> validate_required(~w(id title slug)a)
    |> cast_embed(:video)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
