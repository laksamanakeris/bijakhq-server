defmodule BijakhqWeb.Api.PushMessageControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.PushMessage

  @create_attrs %{is_completed: true, messages: "some messages", total_tokens: 42}
  @update_attrs %{is_completed: false, messages: "some updated messages", total_tokens: 43}
  @invalid_attrs %{is_completed: nil, messages: nil, total_tokens: nil}

  def fixture(:push_message) do
    {:ok, push_message} = PushNotifications.create_push_message(@create_attrs)
    push_message
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all push_messages", %{conn: conn} do
      conn = get conn, api_push_message_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create push_message" do
    test "renders push_message when data is valid", %{conn: conn} do
      conn = post conn, api_push_message_path(conn, :create), push_message: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_push_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_completed" => true,
        "messages" => "some messages",
        "total_tokens" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_push_message_path(conn, :create), push_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update push_message" do
    setup [:create_push_message]

    test "renders push_message when data is valid", %{conn: conn, push_message: %PushMessage{id: id} = push_message} do
      conn = put conn, api_push_message_path(conn, :update, push_message), push_message: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_push_message_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_completed" => false,
        "messages" => "some updated messages",
        "total_tokens" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, push_message: push_message} do
      conn = put conn, api_push_message_path(conn, :update, push_message), push_message: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete push_message" do
    setup [:create_push_message]

    test "deletes chosen push_message", %{conn: conn, push_message: push_message} do
      conn = delete conn, api_push_message_path(conn, :delete, push_message)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_push_message_path(conn, :show, push_message)
      end
    end
  end

  defp create_push_message(_) do
    push_message = fixture(:push_message)
    {:ok, push_message: push_message}
  end
end
