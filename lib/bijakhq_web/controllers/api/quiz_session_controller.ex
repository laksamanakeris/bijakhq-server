defmodule BijakhqWeb.Api.QuizSessionController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Quizzes.QuizGameQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete, :list_questions, :show_question, :update_question]

  def index(conn, _params) do
    quiz_sessions = Quizzes.list_quiz_sessions()
    render(conn, "index.json", quiz_sessions: quiz_sessions)
  end

  def create(conn, %{"game" => quiz_session_params}) do
    with {:ok, %QuizSession{} = quiz_session} <- Quizzes.create_quiz_session(quiz_session_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_session_path(conn, :show, quiz_session))
      |> render("show.json", quiz_session: quiz_session)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz_session = Quizzes.get_quiz_session!(id)
    render(conn, "show.json", quiz_session: quiz_session)
  end

  def update(conn, %{"id" => id, "game" => quiz_session_params}) do
    quiz_session = Quizzes.get_quiz_session!(id)

    with {:ok, %QuizSession{} = quiz_session} <- Quizzes.update_quiz_session(quiz_session, quiz_session_params) do
      render(conn, "show.json", quiz_session: quiz_session)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz_session = Quizzes.get_quiz_session!(id)
    with {:ok, %QuizSession{}} <- Quizzes.delete_quiz_session(quiz_session) do
      send_resp(conn, :no_content, "")
    end
  end

  def list_questions(conn, %{"game_id" => id}) do
    session_question = Quizzes.get_questions_by_game_id(id)
    IO.inspect session_question
    render(conn, "session_question.json", session_question: session_question)
  end

  def show_question(conn, %{"game_id" => game_id, "question_id" => question_id}) do
    attrs = %{session_id: game_id, question_id: question_id}
    quiz_session = Quizzes.get_game_question_by!(attrs)
    IO.inspect quiz_session
    render(conn, "session_question_show.json", session_question: quiz_session)
  end

  def update_question(conn, %{"game_id" => game_id, "question_id" => question_id, "question" => data}) do
    attrs = %{session_id: game_id, question_id: question_id}
    session_question = Quizzes.get_game_question_by!(attrs)
    with {:ok, %QuizGameQuestion{} = session_question} <- Quizzes.update_session_question(session_question, data) do
      render(conn, "session_question_show.json", session_question: session_question)
    end
  end
end
