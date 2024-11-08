defmodule Opsmaru.Content.Page do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Pages.Section

  embedded_schema do
    field :title, :string
    field :slug, :string

    embeds_many :sections, Section
  end

  def changeset(page, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      Map.put(params, "id", id)
      |> Map.put("slug", slug)

    page
    |> cast(params, ~w(id slug title)a)
    |> validate_required(~w(id slug title)a)
    |> cast_embed(:sections)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
