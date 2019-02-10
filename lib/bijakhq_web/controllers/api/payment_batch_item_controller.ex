defmodule BijakhqWeb.Api.PaymentBatchItemController do
  use BijakhqWeb, :controller

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatchItem

  action_fallback BijakhqWeb.FallbackController

  def action(conn, _) do
    batch = Payments.get_payment_batch!(conn.params["payment_batch_id"])
    args = [conn, conn.params, batch]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, batch) do
    payment_batch_items = Payments.list_payment_batch_items_by_batch_id(batch.id)
    IO.inspect payment_batch_items
    render(conn, "index.json", payment_batch_items: payment_batch_items)
  end

  def create(conn, %{"payment_batch_item" => payment_batch_item_params}) do
    with {:ok, %PaymentBatchItem{} = payment_batch_item} <- Payments.create_payment_batch_item(payment_batch_item_params) do
      conn
      |> put_status(:created)
      # |> put_resp_header("location", api_payment_batch_item_path(conn, :show, payment_batch_item))
      |> render("show.json", payment_batch_item: payment_batch_item)
    end
  end

  def show(conn, %{"id" => id}) do
    payment_batch_item = Payments.get_payment_batch_item!(id)
    render(conn, "show.json", payment_batch_item: payment_batch_item)
  end

  def update(conn, %{"id" => id, "payment_batch_item" => payment_batch_item_params}) do
    payment_batch_item = Payments.get_payment_batch_item!(id)

    with {:ok, %PaymentBatchItem{} = payment_batch_item} <- Payments.update_payment_batch_item(payment_batch_item, payment_batch_item_params) do
      render(conn, "show.json", payment_batch_item: payment_batch_item)
    end
  end

  def delete(conn, %{"id" => id}) do
    payment_batch_item = Payments.get_payment_batch_item!(id)
    with {:ok, %PaymentBatchItem{}} <- Payments.delete_payment_batch_item(payment_batch_item) do
      send_resp(conn, :no_content, "")
    end
  end
end
