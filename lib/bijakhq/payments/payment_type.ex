defmodule Bijakhq.Payments.PaymentType do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Payments.PaymentRequest

  schema "payment_types" do
    field :name, :string
    field :description, :string
    field :configuration, :string

    has_many :payments, PaymentRequest, foreign_key: :payment_type

    timestamps()
  end

  @doc false
  def changeset(payment_type, attrs) do
    payment_type
    |> cast(attrs, [:name, :description, :configuration])
    |> validate_required([:name])
    |> unique_name
  end

  defp unique_name(changeset) do
    validate_length(changeset, :name, min: 3)
    |> unique_constraint(:name)
  end
end
