defmodule BijakhqWeb.Api.PaymentStatusView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentStatusView

  def render("index.json", %{payment_statuses: payment_statuses}) do
    %{data: render_many(payment_statuses, PaymentStatusView, "payment_status.json")}
  end

  def render("show.json", %{payment_status: payment_status}) do
    %{data: render_one(payment_status, PaymentStatusView, "payment_status.json")}
  end

  def render("payment_status.json", %{payment_status: payment_status}) do
    %{id: payment_status.id,
      name: payment_status.name,
      description: payment_status.description}
  end
end
