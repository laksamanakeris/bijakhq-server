defmodule BijakhqWeb.Api.PaymentStatusController do
  use BijakhqWeb, :controller

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentStatus

  action_fallback BijakhqWeb.Api.FallbackController

  def index(conn, _params) do
    payment_statuses = Payments.list_payment_statuses()
    render(conn, "index.json", payment_statuses: payment_statuses)
  end

  def create(conn, %{"payment_status" => payment_status_params}) do
    with {:ok, %PaymentStatus{} = payment_status} <- Payments.create_payment_status(payment_status_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", payment_status_path(conn, :show, payment_status))
      |> render("show.json", payment_status: payment_status)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_status = Payments.get_payment_status!(id)
    render(conn, "show.json", payment_status: payment_status)
  end

  def update(conn, %{"id" => id, "payment_status" => payment_status_params}) do
    payment_status = Payments.get_payment_status!(id)

    with {:ok, %PaymentStatus{} = payment_status} <- Payments.update_payment_status(payment_status, payment_status_params) do
      render(conn, "show.json", payment_status: payment_status)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_status = Payments.get_payment_status!(id)
    with {:ok, %PaymentStatus{}} <- Payments.delete_payment_status(payment_status) do
      send_resp(conn, :no_content, "")
    end
  end
end
