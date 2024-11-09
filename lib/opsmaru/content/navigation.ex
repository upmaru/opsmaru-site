defmodule Opsmaru.Content.Navigation do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :slug, :string

    embeds_many :links, Link do
      @derive Jason.Encoder

      field :title, :string
      field :path, :string
      field :index, :integer
    end
  end

  def changeset(navigation, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    navigation
    |> cast(params, ~w(id slug)a)
    |> validate_required(~w(id slug)a)
    |> cast_embed(:links, with: &link_changeset/2)
  end

  defp link_changeset(link, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    link
    |> cast(params, ~w(id title path index)a)
    |> validate_required(~w(id title path index)a)
  end

  def parse(params) do
    navigation =
      %__MODULE__{}
      |> changeset(params)
      |> apply_action!(:insert)

    links = Enum.sort_by(navigation.links, & &1.index, :asc)

    %{navigation | links: links}
  end
end
