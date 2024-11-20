defmodule Opsmaru.Content.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :playback_id, :string
  end

  def changeset(video, params) do
    %{"asset" => %{"_id" => id, "playbackId" => playback_id}} = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("playback_id", playback_id)

    video
    |> cast(params, ~w(id playback_id)a)
    |> validate_required(~w(id playback_id)a)
  end
end
