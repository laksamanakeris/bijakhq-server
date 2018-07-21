defmodule BijakhqWeb.Api.SessionQuestionControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.SessionQuestion

  @create_attrs %{is_completed: true, sequence: 42, total_correct: 42}
  @update_attrs %{is_completed: false, sequence: 43, total_correct: 43}
  @invalid_attrs %{is_completed: nil, sequence: nil, total_correct: nil}

  def fixture(:session_question) do
    {:ok, session_question} = Quizzes.create_session_question(@create_attrs)
    session_question
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all quiz_session_question", %{conn: conn} do
      conn = get conn, api_session_question_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create session_question" do
    test "renders session_question when data is valid", %{conn: conn} do
      conn = post conn, api_session_question_path(conn, :create), session_question: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, api_session_question_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_completed" => true,
        "sequence" => 42,
        "total_correct" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, api_session_question_path(conn, :create), session_question: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update session_question" do
    setup [:create_session_question]

    test "renders session_question when data is valid", %{conn: conn, session_question: %SessionQuestion{id: id} = session_question} do
      conn = put conn, api_session_question_path(conn, :update, session_question), session_question: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, api_session_question_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "is_completed" => false,
        "sequence" => 43,
        "total_correct" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, session_question: session_question} do
      conn = put conn, api_session_question_path(conn, :update, session_question), session_question: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete session_question" do
    setup [:create_session_question]

    test "deletes chosen session_question", %{conn: conn, session_question: session_question} do
      conn = delete conn, api_session_question_path(conn, :delete, session_question)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, api_session_question_path(conn, :show, session_question)
      end
    end
  end

  defp create_session_question(_) do
    session_question = fixture(:session_question)
    {:ok, session_question: session_question}
  end
end
