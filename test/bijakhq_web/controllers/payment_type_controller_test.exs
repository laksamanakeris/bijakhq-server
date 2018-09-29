defmodule BijakhqWeb.PaymentTypeControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentType

  @create_attrs %{configuration: "some configuration", description: "some description", name: "some name"}
  @update_attrs %{configuration: "some updated configuration", description: "some updated description", name: "some updated name"}
  @invalid_attrs %{configuration: nil, description: nil, name: nil}

  def fixture(:payment_type) do
    {:ok, payment_type} = Payments.create_payment_type(@create_attrs)
    payment_type
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all payment_types", %{conn: conn} do
      conn = get conn, payment_type_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create payment_type" do
    test "renders payment_type when data is valid", %{conn: conn} do
      conn = post conn, payment_type_path(conn, :create), payment_type: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, payment_type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "configuration" => "some configuration",
        "description" => "some description",
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, payment_type_path(conn, :create), payment_type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update payment_type" do
    setup [:create_payment_type]

    test "renders payment_type when data is valid", %{conn: conn, payment_type: %PaymentType{id: id} = payment_type} do
      conn = put conn, payment_type_path(conn, :update, payment_type), payment_type: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, payment_type_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "configuration" => "some updated configuration",
        "description" => "some updated description",
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, payment_type: payment_type} do
      conn = put conn, payment_type_path(conn, :update, payment_type), payment_type: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete payment_type" do
    setup [:create_payment_type]

    test "deletes chosen payment_type", %{conn: conn, payment_type: payment_type} do
      conn = delete conn, payment_type_path(conn, :delete, payment_type)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, payment_type_path(conn, :show, payment_type)
      end
    end
  end

  defp create_payment_type(_) do
    payment_type = fixture(:payment_type)
    {:ok, payment_type: payment_type}
  end
end
