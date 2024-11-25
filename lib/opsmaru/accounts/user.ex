defmodule Opsmaru.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :username, :string
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:id, :username])
  end
end
