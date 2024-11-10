defmodule Opsmaru.Content.Post do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(
    id
    title
    slug
    cover
    blurb
    content
    featured
    published_at
  )a

  embedded_schema do
    field :title, :string
    field :slug, :string
    field :cover, :string

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
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
