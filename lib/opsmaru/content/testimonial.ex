defmodule Opsmaru.Content.Testimonial do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image

  @derive Jason.Encoder

  embedded_schema do
    field :name, :string
    field :quote, :string
    field :position, :string

    embeds_one :cover, Image
  end

  def changeset(testmonial, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    testmonial
    |> cast(params, [:id, :name, :quote, :position])
    |> validate_required([:id, :name, :quote, :position])
    |> cast_embed(:cover)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
