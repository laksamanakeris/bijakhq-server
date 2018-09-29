defmodule Bijakhq.Payments.PaymentType do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Payments.Payment

  schema "payment_types" do
    field :name, :string
    field :description, :string
    field :configuration, :string

    has_many :payments, Payment, foreign_key: :payment_type

    timestamps()
  end

  @doc false
  def changeset(payment_type, attrs) do
    payment_type
    |> cast(attrs, [:name, :description, :configuration])
    |> validate_required([:name])
  end
end
