defmodule BijakhqWeb.Api.QuizUserControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizUser

  @create_attrs %{is_player: true, is_viewer: true}
  @update_attrs %{is_player: false, is_viewer: false}
  @invalid_attrs %{is_player: nil, is_viewer: nil}

  def fixture(:quiz_user) do
    {:ok, quiz_user} = Quizzes.create_quiz_user(@create_attrs)
    quiz_user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all quiz_game_users", %{conn: conn} do
      conn = get conn, api_quiz_user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create quiz_user" do
    test "renders quiz_user when data is valid", %{conn: conn} do
      conn = post conn, api_quiz_user_path(conn, :create), quiz_user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_quiz_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_player" => true,
        "is_viewer" => true}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_quiz_user_path(conn, :create), quiz_user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update quiz_user" do
    setup [:create_quiz_user]

    test "renders quiz_user when data is valid", %{conn: conn, quiz_user: %QuizUser{id: id} = quiz_user} do
      conn = put conn, api_quiz_user_path(conn, :update, quiz_user), quiz_user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_quiz_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_player" => false,
        "is_viewer" => false}
    end

    test "renders errors when data is invalid", %{conn: conn, quiz_user: quiz_user} do
      conn = put conn, api_quiz_user_path(conn, :update, quiz_user), quiz_user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete quiz_user" do
    setup [:create_quiz_user]

    test "deletes chosen quiz_user", %{conn: conn, quiz_user: quiz_user} do
      conn = delete conn, api_quiz_user_path(conn, :delete, quiz_user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_quiz_user_path(conn, :show, quiz_user)
      end
    end
  end

  defp create_quiz_user(_) do
    quiz_user = fixture(:quiz_user)
    {:ok, quiz_user: quiz_user}
  end
end
