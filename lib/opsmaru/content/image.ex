defmodule Opsmaru.Content.Image do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :url, :string
    field :alt, :string
  end

  def changeset(image, params) do
    image
    |> cast(params, ~w(url alt)a)
    |> validate_required(~w(url alt)a)
  end

  def url(%__MODULE__{url: url}, options \\ []) do
    uri = URI.parse(url)

    %{uri | query: URI.encode_query(options)}
    |> URI.to_string()
  end
end