defmodule Bijakhq.Payments.PaymentBatch do
  use Ecto.Schema
  import Ecto.Changeset


  schema "payment_batches" do
    field :date_processed, :naive_datetime
    field :name, :string
    field :description, :string
    field :is_processed, :boolean, default: false
    field :generated_request, :map

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
