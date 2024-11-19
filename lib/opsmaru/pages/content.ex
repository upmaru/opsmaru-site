defmodule Opsmaru.Pages.Content do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :slug, :string
    field :body, :string

    field :markdown, :string

    field :published_at, :date
  end

  def changeset(content, params) do
    %{"_id" => id} = params

    params = Map.put(params, "id", id)

    content
    |> cast(params, ~w(id slug body markdown published_at)a)
    |> validate_required(~w(id slug)a)
  end
end
