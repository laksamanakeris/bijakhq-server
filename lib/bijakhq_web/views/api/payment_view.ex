defmodule BijakhqWeb.Api.PaymentView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentView
  alias BijakhqWeb.Api.UserView
  alias BijakhqWeb.Api.PaymentStatusView
  alias BijakhqWeb.Api.PaymentTypeView

  def render("index.json", %{payments: payments}) do
    %{data: render_many(payments, PaymentView, "payment.json")}
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
      updated_by: payment.updated_by,
      inserted_at: payment.inserted_at,
      updated_at: payment.updated_at,
      payment_status: payment.payment_status,
      paypal_email: payment.paypal_email,
      status: render_one(payment.status, PaymentStatusView, "payment_status.json"),
      payment_type: payment.payment_type,
      type: render_one(payment.type, PaymentTypeView, "payment_type.json"),
      user: render_one(payment.user, UserView, "user.json"),
      update_by: render_one(payment.update_by, UserView, "user.json")
    }
  end

  def render("balance.json", %{balance: balance}) do
    %{balance: balance}
  end
end
