defmodule Opsmaru.Content.Movie do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :title, :string
    field :slug, :string

    embeds_one :video, Video do
      @derive Jason.Encoder

      field :playback_id, :string
    end
  end

  def changeset(movie, params) do
    %{"_id" => id, "slug" => %{"current" => slug}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("slug", slug)

    movie
    |> cast(params, ~w(id title slug)a)
    |> validate_required(~w(id title slug)a)
    |> cast_embed(:video, with: &video_changeset/2)
  end

  defp video_changeset(video, params) do
    %{"asset" => %{"_id" => id, "playbackId" => playback_id}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("playback_id", playback_id)

    video
    |> cast(params, ~w(id playback_id)a)
    |> validate_required(~w(id playback_id)a)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
