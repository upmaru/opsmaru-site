defmodule Opsmaru.Commerce.Metadata do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_attrs ~w(
    auto_ssl
    featured
    index
    monthly_deployment_limit
    node_count_limit
    provision_fee_percent
    user_count_limit
  )a

  @primary_key false
  embedded_schema do
    field :auto_ssl, :boolean
    field :featured, :boolean
    field :index, :integer
    field :monthly_deployment_limit, :integer
    field :node_count_limit, :integer
    field :provision_fee_percent, :decimal
    field :user_count_limit, :integer
  end

  def changeset(metadata, params) do
    metadata
    |> cast(params, @valid_attrs)
    |> validate_required(@valid_attrs)
  end

  def parse(params) do
    %__MODULE__{}
    |> changeset(params)
    |> apply_action!(:insert)
  end
end
