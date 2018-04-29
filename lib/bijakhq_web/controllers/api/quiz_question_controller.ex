defmodule BijakhqWeb.Api.QuizQuestionController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  def index(conn, _params) do
    quiz_questions = Quizzes.list_quiz_questions()
    render(conn, "index.json", quiz_questions: quiz_questions)
  end

  def create(conn, %{"quiz_question" => quiz_question_params}) do
    with {:ok, %QuizQuestion{} = quiz_question} <- Quizzes.create_quiz_question(quiz_question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_question_path(conn, :show, quiz_question))
      |> render("show.json", quiz_question: quiz_question)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz_question = Quizzes.get_quiz_question!(id)
    render(conn, "show.json", quiz_question: quiz_question)
  end

  def update(conn, %{"id" => id, "quiz_question" => quiz_question_params}) do
    quiz_question = Quizzes.get_quiz_question!(id)

    with {:ok, %QuizQuestion{} = quiz_question} <- Quizzes.update_quiz_question(quiz_question, quiz_question_params) do
      render(conn, "show.json", quiz_question: quiz_question)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz_question = Quizzes.get_quiz_question!(id)
    with {:ok, %QuizQuestion{}} <- Quizzes.delete_quiz_question(quiz_question) do
      send_resp(conn, :no_content, "")
    end
  end
end
