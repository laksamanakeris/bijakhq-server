defmodule BijakhqWeb.Api.PaymentTypeController do
  use BijakhqWeb, :controller

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentType

  action_fallback BijakhqWeb.Api.FallbackController

  def index(conn, _params) do
    payment_types = Payments.list_payment_types()
    render(conn, "index.json", payment_types: payment_types)
  end

  def create(conn, %{"payment_type" => payment_type_params}) do
    with {:ok, %PaymentType{} = payment_type} <- Payments.create_payment_type(payment_type_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_payment_type_path(conn, :show, payment_type))
      |> render("show.json", payment_type: payment_type)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_type = Payments.get_payment_type!(id)
    render(conn, "show.json", payment_type: payment_type)
  end

  def update(conn, %{"id" => id, "payment_type" => payment_type_params}) do
    payment_type = Payments.get_payment_type!(id)

    with {:ok, %PaymentType{} = payment_type} <- Payments.update_payment_type(payment_type, payment_type_params) do
      render(conn, "show.json", payment_type: payment_type)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_type = Payments.get_payment_type!(id)
    with {:ok, %PaymentType{}} <- Payments.delete_payment_type(payment_type) do
      send_resp(conn, :no_content, "")
    end
  end
end
