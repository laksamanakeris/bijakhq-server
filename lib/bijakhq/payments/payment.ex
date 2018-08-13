defmodule Bijakhq.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_history" do
    field :amount, :float
    field :payment_at, :utc_datetime
    field :remarks, :string
    field :updated_by, :integer
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :user_id, :payment_at, :remarks, :updated_by])
    |> validate_required([:amount, :user_id, :payment_at, :remarks, :updated_by])
  end
end
