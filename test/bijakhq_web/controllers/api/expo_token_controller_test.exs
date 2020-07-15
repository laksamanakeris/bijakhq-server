defmodule BijakhqWeb.Api.ExpoTokenControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.ExpoToken

  @create_attrs %{is_active: true, platform: "some platform", token: "some token"}
  @update_attrs %{is_active: false, platform: "some updated platform", token: "some updated token"}
  @invalid_attrs %{is_active: nil, platform: nil, token: nil}

  def fixture(:expo_token) do
    {:ok, expo_token} = PushNotifications.create_expo_token(@create_attrs)
    expo_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all expo_tokens", %{conn: conn} do
      conn = get conn, api_expo_token_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create expo_token" do
    test "renders expo_token when data is valid", %{conn: conn} do
      conn = post conn, api_expo_token_path(conn, :create), expo_token: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_expo_token_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => true,
        "platform" => "some platform",
        "token" => "some token"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_expo_token_path(conn, :create), expo_token: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update expo_token" do
    setup [:create_expo_token]

    test "renders expo_token when data is valid", %{conn: conn, expo_token: %ExpoToken{id: id} = expo_token} do
      conn = put conn, api_expo_token_path(conn, :update, expo_token), expo_token: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_expo_token_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_active" => false,
        "platform" => "some updated platform",
        "token" => "some updated token"}
    end

    test "renders errors when data is invalid", %{conn: conn, expo_token: expo_token} do
      conn = put conn, api_expo_token_path(conn, :update, expo_token), expo_token: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete expo_token" do
    setup [:create_expo_token]

    test "deletes chosen expo_token", %{conn: conn, expo_token: expo_token} do
      conn = delete conn, api_expo_token_path(conn, :delete, expo_token)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_expo_token_path(conn, :show, expo_token)
      end
    end
  end

  defp create_expo_token(_) do
    expo_token = fixture(:expo_token)
    {:ok, expo_token: expo_token}
  end
end
