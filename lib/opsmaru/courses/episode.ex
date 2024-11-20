defmodule Opsmaru.Courses.Episode do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Author
  alias Opsmaru.Content.Video

  embedded_schema do
    field :title, :string
    field :slug, :string

    field :content, :string

    embeds_one :author, Author

    embeds_one :video, Video
  end

  def changeset(episode, params) do
    episode
    |> cast(params, ~w(title slug)a)
    |> validate_required(~w(title slug)a)
  end
end
