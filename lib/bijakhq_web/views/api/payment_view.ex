defmodule BijakhqWeb.Api.PaymentView do
  use BijakhqWeb, :view
  alias BijakhqWeb.PaymentView

  def render("index.json", %{payment_history: payment_history}) do
    %{data: render_many(payment_history, PaymentView, "payment.json")}
  end

  def render("show.json", %{payment: payment}) do
    %{data: render_one(payment, PaymentView, "payment.json")}
  end

  def render("payment.json", %{payment: payment}) do
    %{id: payment.id,
      amount: payment.amount,
      user_id: payment.user_id,
      payment_at: payment.payment_at,
      remarks: payment.remarks,
      updated_by: payment.updated_by}
  end
end
