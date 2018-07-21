defmodule BijakhqWeb.Api.GameQuestionController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizGameQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  def index(conn, _params) do
    quiz_game_question = Quizzes.list_quiz_game_question()
    render(conn, "index.json", quiz_game_question: quiz_game_question)
  end

  def create(conn, %{"game_question" => session_question_params}) do
    with {:ok, %QuizGameQuestion{} = game_question} <- Quizzes.create_game_question(session_question_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_session_game_question_path(conn, :show, game_question))
      |> render("show.json", game_question: game_question)
    end
  end

  def show(conn, %{"id" => id}) do
    game_question = Quizzes.get_game_question!(id)
    render(conn, "show.json", game_question: game_question)
  end

  def update(conn, %{"id" => id, "game_question" => session_question_params}) do
    game_question = Quizzes.get_game_question!(id)

    with {:ok, %QuizGameQuestion{} = game_question} <- Quizzes.update_game_question(game_question, session_question_params) do
      render(conn, "show.json", game_question: game_question)
    end
  end

  def delete(conn, %{"id" => id}) do
    game_question = Quizzes.get_game_question!(id)
    with {:ok, %QuizGameQuestion{}} <- Quizzes.delete_game_question(game_question) do
      send_resp(conn, :no_content, "")
    end
  end
end
