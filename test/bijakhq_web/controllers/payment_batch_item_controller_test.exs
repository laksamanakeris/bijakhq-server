defmodule BijakhqWeb.PaymentBatchItemControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatchItem

  @create_attrs %{batch_id: 42, payment_id: 42, status: 42}
  @update_attrs %{batch_id: 43, payment_id: 43, status: 43}
  @invalid_attrs %{batch_id: nil, payment_id: nil, status: nil}

  def fixture(:payment_batch_item) do
    {:ok, payment_batch_item} = Payments.create_payment_batch_item(@create_attrs)
    payment_batch_item
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_batch_items", %{conn: conn} do
      conn = get conn, payment_batch_item_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_batch_item" do
    test "renders payment_batch_item when data is valid", %{conn: conn} do
      conn = post conn, payment_batch_item_path(conn, :create), payment_batch_item: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, payment_batch_item_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "batch_id" => 42,
        "payment_id" => 42,
        "status" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_batch_item_path(conn, :create), payment_batch_item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_batch_item" do
    setup [:create_payment_batch_item]

    test "renders payment_batch_item when data is valid", %{conn: conn, payment_batch_item: %PaymentBatchItem{id: id} = payment_batch_item} do
      conn = put conn, payment_batch_item_path(conn, :update, payment_batch_item), payment_batch_item: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, payment_batch_item_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "batch_id" => 43,
        "payment_id" => 43,
        "status" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, payment_batch_item: payment_batch_item} do
      conn = put conn, payment_batch_item_path(conn, :update, payment_batch_item), payment_batch_item: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_batch_item" do
    setup [:create_payment_batch_item]

    test "deletes chosen payment_batch_item", %{conn: conn, payment_batch_item: payment_batch_item} do
      conn = delete conn, payment_batch_item_path(conn, :delete, payment_batch_item)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, payment_batch_item_path(conn, :show, payment_batch_item)
      end
    end
  end

  defp create_payment_batch_item(_) do
    payment_batch_item = fixture(:payment_batch_item)
    {:ok, payment_batch_item: payment_batch_item}
  end
end
