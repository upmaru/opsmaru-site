defmodule Opsmaru.Pages.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image

  @valid_attrs ~w(id position heading slug title description)a

  embedded_schema do
    field :position, :string
    field :slug, :string
    field :heading, :string
    field :title, :string
    field :description, :string

    embeds_one :cover, Image
  end

  def changeset(card, params) do
    %{
      "_id" => id,
      "card" => %{
        "title" => title,
        "heading" => heading,
        "description" => description,
        "slug" => %{"current" => slug},
        "cover" => cover_params
      }
    } = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)
      |> Map.put("title", title)
      |> Map.put("description", description)
      |> Map.put("heading", heading)
      |> Map.put("cover", cover_params)

    card
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
    |> cast_embed(:cover)
  end
end
