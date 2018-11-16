defmodule Bijakhq.Payments.PaymentBatchItem do
  use Ecto.Schema
  import Ecto.Changeset


  alias Bijakhq.Payments.Payment
  alias Bijakhq.Payments.PaymentBatch

  schema "payment_batch_items" do
    
    field :status, :integer, default: 1  #1=pending, 2=accepted, 3=rejected

    belongs_to :payment, Payment, foreign_key: :payment_id
    belongs_to :batch, PaymentBatch, foreign_key: :batch_id
    # field :batch_id, :integer
    # field :payment_id, :integer

    timestamps()
  end

  @doc false
  def changeset(payment_batch_item, attrs) do
    payment_batch_item
    |> cast(attrs, [:batch_id, :payment_id, :status])
    |> validate_required([:batch_id, :payment_id])
    # Note that the constaint is placed on ONE of the fields.
    |> unique_constraint(:batch_id, name: :index_batches_payments)
  end
end
