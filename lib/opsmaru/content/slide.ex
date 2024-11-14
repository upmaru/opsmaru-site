defmodule Opsmaru.Content.Slide do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image

  embedded_schema do
    field :title, :string

    embeds_one :image, Image
  end

  def changeset(slide, params) do
    slide
    |> cast(params, ~w(title)a)
    |> validate_required(~w(title)a)
    |> cast_embed(:image)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
