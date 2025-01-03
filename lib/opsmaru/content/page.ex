defmodule Opsmaru.Content.Page do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Pages.Section
  alias Opsmaru.Content.Image

  embedded_schema do
    field :title, :string
    field :slug, :string
    field :description, :string

    embeds_one :cover, Image

    embeds_many :sections, Section
  end

  def changeset(page, params) do
    %{"_id" => id, "cover" => cover_params, "slug" => %{"current" => slug}} = params

    params =
      Map.put(params, "id", id)
      |> Map.put("slug", slug)
      |> Map.put("cover", Image.params(cover_params))

    page
    |> cast(params, ~w(id slug title description)a)
    |> validate_required(~w(id slug title)a)
    |> cast_embed(:sections)
    |> cast_embed(:cover)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
