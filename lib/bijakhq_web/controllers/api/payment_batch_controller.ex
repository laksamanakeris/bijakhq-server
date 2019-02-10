defmodule BijakhqWeb.Api.PaymentBatchController do
  use BijakhqWeb, :controller

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatch

  action_fallback BijakhqWeb.FallbackController

  def index(conn, _params) do
    payment_batches = Payments.list_payment_batches()
    render(conn, "index.json", payment_batches: payment_batches)
  end

  def create(conn, %{"payment_batch" => payment_batch_params}) do
    with {:ok, %PaymentBatch{} = payment_batch} <- Payments.create_payment_batch(payment_batch_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_payment_batch_path(conn, :show, payment_batch))
      |> render("show.json", payment_batch: payment_batch)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_batch = Payments.get_payment_batch!(id)
    render(conn, "show.json", payment_batch: payment_batch)
  end

  def update(conn, %{"id" => id, "payment_batch" => payment_batch_params}) do
    payment_batch = Payments.get_payment_batch!(id)

    with {:ok, %PaymentBatch{} = payment_batch} <- Payments.update_payment_batch(payment_batch, payment_batch_params) do
      render(conn, "show.json", payment_batch: payment_batch)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_batch = Payments.get_payment_batch!(id)
    with {:ok, %PaymentBatch{}} <- Payments.delete_payment_batch(payment_batch) do
      send_resp(conn, :no_content, "")
    end
  end

  def create_new_batch(conn, _params) do
    result = Payments.create_new_batch_request()
    case result do
      {:error, msg} ->
        conn
        |> put_status(:not_found)
        |> put_view(BijakhqWeb.ErrorView)
        |> render("error.json", msg)
      {:ok, batch} ->
        render(conn, "show.json", payment_batch: batch)
    end
  end

  def get_paypal_update(conn, %{"id" => id}) do
    result = Payments.update_batch_status(id)
    case result do
      {:error, msg} ->
        conn
        |> put_status(:not_found)
        |> put_view(BijakhqWeb.ErrorView)
        |> render("error.json", msg)
      {:ok, payload} ->
        json(conn, %{
          paypal: payload
        })
    end
  end
end
