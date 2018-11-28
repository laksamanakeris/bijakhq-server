defmodule Bijakhq.Payments.PaymentStatus do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Payments.PaymentRequest


  @doc """
  List of payment statuses

  statuses = [
    %{name: "New", description: "New request"},
    %{name: "Processed", description: "Payment request is being processed"},
    %{name: "Pending confirmation", description: "Pending confirmation from Payment Provider"},
    %{name: "Paid", description: "Paid"},
    %{name: "Failed", description: "Payment request failed"}
    %{name: "Canceled", description: "Payment request has been canceled"}
  ]
  """

  schema "payment_statuses" do
    field :description, :string
    field :name, :string

    has_many :payments, PaymentRequest, foreign_key: :payment_status
    timestamps()
  end

  @doc false
  def changeset(payment_status, attrs) do
    payment_status
    |> cast(attrs, [:name, :description])
    |> validate_required([:name])
    |> unique_name
  end

  defp unique_name(changeset) do
    validate_length(changeset, :name, min: 3)
    |> unique_constraint(:name)
  end
end
