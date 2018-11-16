defmodule Bijakhq.Payments.PaymentBatchItem do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_batch_items" do
    field :batch_id, :integer
    field :payment_id, :integer
    field :status, :integer

    timestamps()
  end

  @doc false
  def changeset(payment_batch_item, attrs) do
    payment_batch_item
    |> cast(attrs, [:batch_id, :payment_id, :status])
    |> validate_required([:batch_id, :payment_id, :status])
  end
end
