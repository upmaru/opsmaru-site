defmodule Opsmaru.Courses.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Author
  alias Opsmaru.Content.Video

  embedded_schema do
    field :title, :string
    field :slug, :string
    field :index, :integer

    field :content, :string

    embeds_one :author, Author

    embeds_one :video, Video
  end

  def changeset(episode, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    episode
    |> cast(params, ~w(title slug index)a)
    |> validate_required(~w(title slug index)a)
    |> cast_embed(:author)
    |> cast_embed(:video)
  end
end
