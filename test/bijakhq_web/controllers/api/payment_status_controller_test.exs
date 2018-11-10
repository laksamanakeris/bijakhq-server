defmodule BijakhqWeb.Api.PaymentStatusControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentStatus

  @create_attrs %{description: "some description", name: "some name"}
  @update_attrs %{description: "some updated description", name: "some updated name"}
  @invalid_attrs %{description: nil, name: nil}

  def fixture(:payment_status) do
    {:ok, payment_status} = Payments.create_payment_status(@create_attrs)
    payment_status
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_statuses", %{conn: conn} do
      conn = get conn, api_payment_status_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_status" do
    test "renders payment_status when data is valid", %{conn: conn} do
      conn = post conn, api_payment_status_path(conn, :create), payment_status: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_payment_status_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some description",
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_payment_status_path(conn, :create), payment_status: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_status" do
    setup [:create_payment_status]

    test "renders payment_status when data is valid", %{conn: conn, payment_status: %PaymentStatus{id: id} = payment_status} do
      conn = put conn, api_payment_status_path(conn, :update, payment_status), payment_status: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_payment_status_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "description" => "some updated description",
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, payment_status: payment_status} do
      conn = put conn, api_payment_status_path(conn, :update, payment_status), payment_status: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_status" do
    setup [:create_payment_status]

    test "deletes chosen payment_status", %{conn: conn, payment_status: payment_status} do
      conn = delete conn, api_payment_status_path(conn, :delete, payment_status)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_payment_status_path(conn, :show, payment_status)
      end
    end
  end

  defp create_payment_status(_) do
    payment_status = fixture(:payment_status)
    {:ok, payment_status: payment_status}
  end
end
