defmodule BijakhqWeb.Api.GameQuestionController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizGameQuestion
  alias Bijakhq.Quizzes.QuizSession

  action_fallback BijakhqWeb.Api.FallbackController

  def action(conn, _) do
    game = Quizzes.get_quiz_session!(conn.params["quiz_session_id"])
    args = [conn, conn.params, game]
    apply(__MODULE__, action_name(conn), args)
  end

  def index(conn, _params, game) do
    quiz_game_question = Quizzes.get_questions_by_game_id(game.id)
    # IO.inspect game_question
    # render(conn, "game_question.json", game_question: game_question)

    # quiz_game_question = Quizzes.list_quiz_game_question()
    render(conn, "index_preload.json", quiz_game_question: quiz_game_question)
  end

  def create(conn, %{"game_question" => session_question_params}) do
    with {:ok, %QuizGameQuestion{} = game_question} <- Quizzes.create_game_question(session_question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_session_game_question_path(conn, :show, game_question))
      |> render("show.json", game_question: game_question)
    end
  end

  def show(conn, %{"id" => id}, game) do
    # game_question = Quizzes.get_game_question!(id)
    attrs = %{session_id: game.id, question_id: id}
    game_question = Quizzes.get_game_question_by!(attrs)
    render(conn, "show_preload.json", game_question: game_question)
  end

  def update(conn, %{"id" => id, "question" => session_question_params}, game) do
    attrs = %{session_id: game.id, question_id: id}
    game_question = Quizzes.get_game_question_by!(attrs)
    with {:ok, %QuizGameQuestion{} = game_question} <- Quizzes.update_game_question(game_question, session_question_params) do
      render(conn, "show_preload.json", game_question: game_question)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_question = Quizzes.get_game_question!(id)
    with {:ok, %QuizGameQuestion{}} <- Quizzes.delete_game_question(game_question) do
      send_resp(conn, :no_content, "")
    end
  end
end
