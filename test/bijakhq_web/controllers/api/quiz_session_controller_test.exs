defmodule BijakhqWeb.Api.QuizSessionControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizSession

  # @create_attrs %{completed_at: "2010-04-17 14:00:00.000000Z", description: "some description", is_active: true, is_completed: true, name: "some name", prize: "some prize", prize_description: "some prize_description", time: "2010-04-17 14:00:00.000000Z", total_questions: 42}
  # @update_attrs %{completed_at: "2011-05-18 15:01:01.000000Z", description: "some updated description", is_active: false, is_completed: false, name: "some updated name", prize: "some updated prize", prize_description: "some updated prize_description", time: "2011-05-18 15:01:01.000000Z", total_questions: 43}
  # @invalid_attrs %{completed_at: nil, description: nil, is_active: nil, is_completed: nil, name: nil, prize: nil, prize_description: nil, time: nil, total_questions: nil}

  # def fixture(:quiz_session) do
  #   {:ok, quiz_session} = Quizzes.create_quiz_session(@create_attrs)
  #   quiz_session
  # end

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # describe "index" do
  #   test "lists all quiz_sessions", %{conn: conn} do
  #     conn = get conn, api_quiz_session_path(conn, :index)
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create quiz_session" do
  #   test "renders quiz_session when data is valid", %{conn: conn} do
  #     conn = post conn, api_quiz_session_path(conn, :create), quiz_session: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, api_quiz_session_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "completed_at" => "2010-04-17 14:00:00.000000Z",
  #       "description" => "some description",
  #       "is_active" => true,
  #       "is_completed" => true,
  #       "name" => "some name",
  #       "prize" => "some prize",
  #       "prize_description" => "some prize_description",
  #       "time" => "2010-04-17 14:00:00.000000Z",
  #       "total_questions" => 42}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, api_quiz_session_path(conn, :create), quiz_session: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update quiz_session" do
  #   setup [:create_quiz_session]

  #   test "renders quiz_session when data is valid", %{conn: conn, quiz_session: %QuizSession{id: id} = quiz_session} do
  #     conn = put conn, api_quiz_session_path(conn, :update, quiz_session), quiz_session: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, api_quiz_session_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "completed_at" => "2011-05-18 15:01:01.000000Z",
  #       "description" => "some updated description",
  #       "is_active" => false,
  #       "is_completed" => false,
  #       "name" => "some updated name",
  #       "prize" => "some updated prize",
  #       "prize_description" => "some updated prize_description",
  #       "time" => "2011-05-18 15:01:01.000000Z",
  #       "total_questions" => 43}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, quiz_session: quiz_session} do
  #     conn = put conn, api_quiz_session_path(conn, :update, quiz_session), quiz_session: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete quiz_session" do
  #   setup [:create_quiz_session]

  #   test "deletes chosen quiz_session", %{conn: conn, quiz_session: quiz_session} do
  #     conn = delete conn, api_quiz_session_path(conn, :delete, quiz_session)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, api_quiz_session_path(conn, :show, quiz_session)
  #     end
  #   end
  # end

  # defp create_quiz_session(_) do
  #   quiz_session = fixture(:quiz_session)
  #   {:ok, quiz_session: quiz_session}
  # end
end
