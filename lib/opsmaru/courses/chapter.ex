defmodule Opsmaru.Courses.Chapter do
  use Ecto.Schema
  import Ecto.Changeset

  alias Opsmaru.Content.Episode

  embedded_schema do
    field :title, :string
    field :slug, :string
    field :index, :integer

    embeds_many :episodes, Episode
  end
end
