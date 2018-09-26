defmodule Bijakhq.Payments.PaymentType do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_types" do
    field :name, :string
    field :description, :string
    field :configuration, :string

    timestamps()
  end

  @doc false
  def changeset(payment_type, attrs) do
    payment_status
    |> cast(attrs, [:name, :description, :configurations])
    |> validate_required([:name])
  end
end
