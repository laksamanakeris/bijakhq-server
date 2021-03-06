defmodule BijakhqWeb.Api.QuizQuestionController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  # the following plugs are defined in the controllers/authorize.ex file
  # plug :user_check when action in [:index, :show]
  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show,:update, :delete]

  def index(conn, params) do
    page = params["page"]
    query = params["query"]
    quiz_questions = Quizzes.list_quiz_questions(page, query)
    render(conn, "index.json", quiz_questions: quiz_questions)
  end

  def create(conn, %{"question" => quiz_question_params}) do
    with {:ok, %QuizQuestion{} = quiz_question} <- Quizzes.create_quiz_question(quiz_question_params) do

      quiz_question = Quizzes.get_quiz_question!(quiz_question.id)

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

  def update(conn, %{"id" => id, "question" => quiz_question_params}) do
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
