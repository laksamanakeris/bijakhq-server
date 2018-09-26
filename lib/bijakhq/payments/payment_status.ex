defmodule Bijakhq.Payments.PaymentStatus do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_statuses" do
    field :description, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(payment_status, attrs) do
    payment_status
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
