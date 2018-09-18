defmodule BijakhqWeb.Api.PaymentView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentView
  alias BijakhqWeb.Api.UserView

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
      user: render_one(payment.user, UserView, "user.json"),
      update_by: render_one(payment.update_by, UserView, "user.json")
    }
  end
end
