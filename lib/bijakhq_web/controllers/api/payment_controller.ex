defmodule BijakhqWeb.Api.PaymentController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Payments
  alias Bijakhq.Payments.Payment

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete]
  plug :user_check when action in [:request_payment]

  def index(conn, _params) do
    payments = Payments.list_payments()
    render(conn, "index.json", payments: payments)
  end

  # def create(conn, %{"payment" => payment_params}) do
  def create(%Plug.Conn{assigns: %{current_user: admin}} = conn, %{"payment" => payment_params}) do
    Map.put(payment_params, :update_by, admin.id)
    with {:ok, %Payment{} = payment} <- Payments.create_payment(payment_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_payment_path(conn, :show, payment))
      |> render("show.json", payment: payment)
    end
  end

  def show(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    render(conn, "show.json", payment: payment)
  end

  def update(%Plug.Conn{assigns: %{current_user: admin}} = conn, %{"id" => id, "payment" => payment_params}) do
    payment = Payments.get_payment!(id)
    Map.put(payment_params, :update_by, admin.id)
    with {:ok, %Payment{} = payment} <- Payments.update_payment(payment, payment_params) do
      render(conn, "show.json", payment: payment)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment = Payments.get_payment!(id)
    with {:ok, %Payment{}} <- Payments.delete_payment(payment) do
      send_resp(conn, :no_content, "")
    end
  end

  def request_payment(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"paypal_email" => email}) do
    with {:ok, balance} <- Payments.request_payment(user, email) do
      render(conn, "balance.json", balance: balance)
    end
  end
end
