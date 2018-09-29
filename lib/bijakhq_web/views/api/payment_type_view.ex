defmodule BijakhqWeb.Api.PaymentTypeView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PaymentTypeView

  def render("index.json", %{payment_types: payment_types}) do
    %{data: render_many(payment_types, PaymentTypeView, "payment_type.json")}
  end

  def render("show.json", %{payment_type: payment_type}) do
    %{data: render_one(payment_type, PaymentTypeView, "payment_type.json")}
  end

  def render("payment_type.json", %{payment_type: payment_type}) do
    %{id: payment_type.id,
      name: payment_type.name,
      description: payment_type.description,
      configuration: payment_type.configuration}
  end
end
