defmodule BijakhqWeb.Api.PaymentControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Payments
  alias Bijakhq.Payments.Payment

  @create_attrs %{amount: 120.5, payment_at: "2010-04-17 14:00:00.000000Z", remarks: "some remarks", updated_by: 42, user_id: 42}
  @update_attrs %{amount: 456.7, payment_at: "2011-05-18 15:01:01.000000Z", remarks: "some updated remarks", updated_by: 43, user_id: 43}
  @invalid_attrs %{amount: nil, payment_at: nil, remarks: nil, updated_by: nil, user_id: nil}

  def fixture(:payment) do
    {:ok, payment} = Payments.create_payment(@create_attrs)
    payment
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_history", %{conn: conn} do
      conn = get conn, payment_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment" do
    test "renders payment when data is valid", %{conn: conn} do
      conn = post conn, payment_path(conn, :create), payment: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 120.5,
        "payment_at" => "2010-04-17 14:00:00.000000Z",
        "remarks" => "some remarks",
        "updated_by" => 42,
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_path(conn, :create), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment" do
    setup [:create_payment]

    test "renders payment when data is valid", %{conn: conn, payment: %Payment{id: id} = payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, payment_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "amount" => 456.7,
        "payment_at" => "2011-05-18 15:01:01.000000Z",
        "remarks" => "some updated remarks",
        "updated_by" => 43,
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, payment: payment} do
      conn = put conn, payment_path(conn, :update, payment), payment: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment" do
    setup [:create_payment]

    test "deletes chosen payment", %{conn: conn, payment: payment} do
      conn = delete conn, payment_path(conn, :delete, payment)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, payment_path(conn, :show, payment)
      end
    end
  end

  defp create_payment(_) do
    payment = fixture(:payment)
    {:ok, payment: payment}
  end
end
