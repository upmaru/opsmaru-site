defmodule Opsmaru.Pages.FAQ do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :index, :integer
    field :question, :string
    field :answer, :string
  end

  def changeset(faq, params) do
    %{"_id" => id, "faq" => faq_params} = params

    params =
      Map.put(params, "id", id)
      |> Map.put("question", faq_params["question"])
      |> Map.put("answer", faq_params["answer"])

    faq
    |> cast(params, ~w(id index question answer)a)
    |> validate_required(~w(id index question answer)a)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
