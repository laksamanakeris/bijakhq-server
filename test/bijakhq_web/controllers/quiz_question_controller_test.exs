defmodule BijakhqWeb.QuizQuestionControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizQuestion

  # @create_attrs %{answer: "some answer", optionB: "some optionB", optionC: "some optionC", question: "some question"}
  # @update_attrs %{answer: "some updated answer", optionB: "some updated optionB", optionC: "some updated optionC", question: "some updated question"}
  # @invalid_attrs %{answer: nil, optionB: nil, optionC: nil, question: nil}

  # def fixture(:quiz_question) do
  #   {:ok, quiz_question} = Quizzes.create_quiz_question(@create_attrs)
  #   quiz_question
  # end

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # describe "index" do
  #   test "lists all quiz_questions", %{conn: conn} do
  #     conn = get conn, quiz_question_path(conn, :index)
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create quiz_question" do
  #   test "renders quiz_question when data is valid", %{conn: conn} do
  #     conn = post conn, quiz_question_path(conn, :create), quiz_question: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, quiz_question_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "answer" => "some answer",
  #       "optionB" => "some optionB",
  #       "optionC" => "some optionC",
  #       "question" => "some question"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, quiz_question_path(conn, :create), quiz_question: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update quiz_question" do
  #   setup [:create_quiz_question]

  #   test "renders quiz_question when data is valid", %{conn: conn, quiz_question: %QuizQuestion{id: id} = quiz_question} do
  #     conn = put conn, quiz_question_path(conn, :update, quiz_question), quiz_question: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, quiz_question_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "answer" => "some updated answer",
  #       "optionB" => "some updated optionB",
  #       "optionC" => "some updated optionC",
  #       "question" => "some updated question"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, quiz_question: quiz_question} do
  #     conn = put conn, quiz_question_path(conn, :update, quiz_question), quiz_question: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete quiz_question" do
  #   setup [:create_quiz_question]

  #   test "deletes chosen quiz_question", %{conn: conn, quiz_question: quiz_question} do
  #     conn = delete conn, quiz_question_path(conn, :delete, quiz_question)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, quiz_question_path(conn, :show, quiz_question)
  #     end
  #   end
  # end

  # defp create_quiz_question(_) do
  #   quiz_question = fixture(:quiz_question)
  #   {:ok, quiz_question: quiz_question}
  # end
end
