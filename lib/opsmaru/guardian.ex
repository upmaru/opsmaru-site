defmodule Opsmaru.Guardian do
  use Guardian, otp_app: :opsmaru

  alias Opsmaru.Accounts.User

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)

    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :invalid_resource}
  end

  def resource_from_claims(%{"sub" => id}) do
    id = String.to_integer(id)

    resource = %User{id: id}

    {:ok, resource}
  end

  def resource_from_claims(_claims) do
    {:error, :invalid_claim}
  end
end
