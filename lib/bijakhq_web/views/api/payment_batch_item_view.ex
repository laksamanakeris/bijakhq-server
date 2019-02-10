defmodule BijakhqWeb.Api.PaymentBatchItemView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentBatchItemView
  alias BijakhqWeb.Api.PaymentView

  def render("index.json", %{payment_batch_items: payment_batch_items}) do
    %{data: render_many(payment_batch_items, PaymentBatchItemView, "payment_batch_item.json")}
  end

  def render("show.json", %{payment_batch_item: payment_batch_item}) do
    %{data: render_one(payment_batch_item, PaymentBatchItemView, "payment_batch_item.json")}
  end

  def render("payment_batch_item.json", %{payment_batch_item: payment_batch_item}) do
    %{id: payment_batch_item.id,
      batch_id: payment_batch_item.batch_id,
      payment_id: payment_batch_item.payment_id,
      # status: payment_batch_item.status,
      details: render_one(payment_batch_item.payment, PaymentView, "payment.json"),
    }
  end
end
