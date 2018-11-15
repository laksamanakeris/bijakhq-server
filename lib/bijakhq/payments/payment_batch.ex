defmodule Bijakhq.Payments.PaymentBatch do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_batches" do
    field :date_processed, :naive_datetime
    field :description, :string
    field :is_processed, :boolean, default: false
    field :generated_request, :json

    timestamps()
  end

  @doc false
  def changeset(payment_batch, attrs) do
    payment_batch
    |> cast(attrs, [:date_processed, :description, :is_processed, :generated_request])
    |> validate_required([:date_processed, :description, :is_processed, :generated_request])
  end
end
