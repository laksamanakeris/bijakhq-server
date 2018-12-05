defmodule BijakhqWeb.Api.QuizUserController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizUser

  action_fallback BijakhqWeb.FallbackController

  def index(conn, _params) do
    quiz_game_users = Quizzes.list_quiz_game_users()
    render(conn, "index.json", quiz_game_users: quiz_game_users)
  end

  def create(conn, %{"quiz_user" => quiz_user_params}) do
    with {:ok, %QuizUser{} = quiz_user} <- Quizzes.create_quiz_user(quiz_user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_user_path(conn, :show, quiz_user))
      |> render("show.json", quiz_user: quiz_user)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz_user = Quizzes.get_quiz_user!(id)
    render(conn, "show.json", quiz_user: quiz_user)
  end

  def update(conn, %{"id" => id, "quiz_user" => quiz_user_params}) do
    quiz_user = Quizzes.get_quiz_user!(id)

    with {:ok, %QuizUser{} = quiz_user} <- Quizzes.update_quiz_user(quiz_user, quiz_user_params) do
      render(conn, "show.json", quiz_user: quiz_user)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz_user = Quizzes.get_quiz_user!(id)
    with {:ok, %QuizUser{}} <- Quizzes.delete_quiz_user(quiz_user) do
      send_resp(conn, :no_content, "")
    end
  end



  def add_extra_life(conn, %{"game_id" => game_id}) do
    quiz_game_users = Quizzes.add_extra_life_to_players_by_game(game_id)
    render(conn, "index.json", quiz_game_users: quiz_game_users)
  end
end
