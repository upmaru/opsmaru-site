defmodule Opsmaru.Content.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  embedded_schema do
    field :playback_id, :string
    field :duration, :decimal
  end

  def changeset(video, params) do
    %{
      "asset" => %{
        "_id" => id,
        "playbackId" => playback_id,
        "data" => %{"duration" => duration}
      }
    } = params

    params =
      params
      |> Map.put("id", id)
      |> Map.put("playback_id", playback_id)
      |> Map.put("duration", duration)

    video
    |> cast(params, ~w(id playback_id duration)a)
    |> validate_required(~w(id playback_id duration)a)
  end

  def duration_display(%__MODULE__{duration: duration}) do
    duration
    |> Decimal.round()
    |> Decimal.to_integer()
    |> DateTime.from_unix!()
    |> Calendar.strftime("%M:%S")
  end
end
