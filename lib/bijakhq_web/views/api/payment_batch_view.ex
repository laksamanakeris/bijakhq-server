defmodule BijakhqWeb.Api.PaymentBatchView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentBatchView

  def render("index.json", %{payment_batches: payment_batches}) do
    %{data: render_many(payment_batches, PaymentBatchView, "payment_batch.json")}
  end

  def render("show.json", %{payment_batch: payment_batch}) do
    %{data: render_one(payment_batch, PaymentBatchView, "payment_batch.json")}
  end

  # field :payout_batch_id, :string 
  #   field :batch_status, :string
  #   field :amount, :float
  #   field :fees, :float
  def render("payment_batch.json", %{payment_batch: payment_batch}) do
    %{id: payment_batch.id,
      date_processed: payment_batch.date_processed,
      name: payment_batch.name,
      description: payment_batch.description,
      is_processed: payment_batch.is_processed,
      generated_request: payment_batch.generated_request,
      payout_batch_id: payment_batch.payout_batch_id,
      batch_status: payment_batch.batch_status,
      amount: payment_batch.amount,
      fees: payment_batch.fees,
    }
  end
end
