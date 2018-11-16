defmodule Bijakhq.Payments.PaymentBatch do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Bijakhq.Payments.Payment
  alias Bijakhq.Payments.PaymentBatchItem
  alias Bijakhq.Payments.Payment


  schema "payment_batches" do
    field :name, :string
    field :description, :string
    field :is_processed, :boolean, default: false
    field :date_processed, :utc_datetime
    field :generated_request, :map

    has_many :items, PaymentBatchItem, foreign_key: :batch_id
    # Batch can have many payments - this will happen when there's issue processing the Paypal Payment 
    many_to_many :payments, Payment, join_through: "payment_batch_items", join_keys: [payment_id: :id, batch_id: :id]

    timestamps()
  end

  @doc false
  def changeset(payment_batch, attrs) do
    payment_batch
    |> cast(attrs, [:name, :date_processed, :description, :is_processed, :generated_request])
    |> validate_required([:name])
    # |> validate_required([:date_processed, :description, :is_processed, :generated_request])
  end
end
