defmodule BijakhqWeb.Api.QuizGameQuestionController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizGameQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  def index(conn, _params) do
    quiz_session_question = Quizzes.list_quiz_session_question()
    render(conn, "index.json", quiz_session_question: quiz_session_question)
  end

  def create(conn, %{"session_question" => session_question_params}) do
    with {:ok, %QuizGameQuestion{} = session_question} <- Quizzes.create_session_question(session_question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_session_question_path(conn, :show, session_question))
      |> render("show.json", session_question: session_question)
    end
  end

  def show(conn, %{"id" => id}) do
    session_question = Quizzes.get_session_question!(id)
    render(conn, "show.json", session_question: session_question)
  end

  def update(conn, %{"id" => id, "session_question" => session_question_params}) do
    session_question = Quizzes.get_session_question!(id)

    with {:ok, %QuizGameQuestion{} = session_question} <- Quizzes.update_session_question(session_question, session_question_params) do
      render(conn, "show.json", session_question: session_question)
    end
  end

  def delete(conn, %{"id" => id}) do
    session_question = Quizzes.get_session_question!(id)
    with {:ok, %QuizGameQuestion{}} <- Quizzes.delete_session_question(session_question) do
      send_resp(conn, :no_content, "")
    end
  end
end
