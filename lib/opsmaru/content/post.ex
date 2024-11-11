defmodule Opsmaru.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Image

  @valid_attrs ~w(
    id
    title
    slug
    blurb
    content
    featured
    published_at
  )a

  embedded_schema do
    field :title, :string
    field :slug, :string

    embeds_one :cover, Image

    embeds_one :author, Author do
      field :name, :string

      embeds_one :avatar, Image
    end

    field :blurb, :string
    field :content, :string
    field :featured, :boolean

    field :published_at, :date
  end

  def changeset(post, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    post
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
    |> cast_embed(:cover)
    |> cast_embed(:author, with: &author_changeset/2)
  end

  defp author_changeset(author, params) do
    %{"_id" => id} = params

    params =
      params
      |> Map.put("id", id)

    author
    |> cast(params, ~w(id name)a)
    |> validate_required(~w(id name)a)
    |> cast_embed(:avatar)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
