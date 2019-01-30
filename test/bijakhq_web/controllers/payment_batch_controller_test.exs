defmodule BijakhqWeb.PaymentBatchControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatch

  @create_attrs %{date_processed: ~N[2010-04-17 14:00:00.000000], description: "some description", is_processed: true}
  @update_attrs %{date_processed: ~N[2011-05-18 15:01:01.000000], description: "some updated description", is_processed: false}
  @invalid_attrs %{date_processed: nil, description: nil, is_processed: nil}

  def fixture(:payment_batch) do
    {:ok, payment_batch} = Payments.create_payment_batch(@create_attrs)
    payment_batch
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_batches", %{conn: conn} do
      conn = get conn, payment_batch_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_batch" do
    test "renders payment_batch when data is valid", %{conn: conn} do
      conn = post conn, payment_batch_path(conn, :create), payment_batch: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, payment_batch_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "date_processed" => ~N[2010-04-17 14:00:00.000000],
        "description" => "some description",
        "is_processed" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_batch_path(conn, :create), payment_batch: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_batch" do
    setup [:create_payment_batch]

    test "renders payment_batch when data is valid", %{conn: conn, payment_batch: %PaymentBatch{id: id} = payment_batch} do
      conn = put conn, payment_batch_path(conn, :update, payment_batch), payment_batch: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, payment_batch_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "date_processed" => ~N[2011-05-18 15:01:01.000000],
        "description" => "some updated description",
        "is_processed" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, payment_batch: payment_batch} do
      conn = put conn, payment_batch_path(conn, :update, payment_batch), payment_batch: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_batch" do
    setup [:create_payment_batch]

    test "deletes chosen payment_batch", %{conn: conn, payment_batch: payment_batch} do
      conn = delete conn, payment_batch_path(conn, :delete, payment_batch)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, payment_batch_path(conn, :show, payment_batch)
      end
    end
  end

  defp create_payment_batch(_) do
    payment_batch = fixture(:payment_batch)
    {:ok, payment_batch: payment_batch}
  end
end
