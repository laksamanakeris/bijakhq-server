defmodule BijakhqWeb.Api.QuizSessionController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Quizzes.QuizGameQuestion

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete, :list_questions, :show_question, :update_question]
  plug :user_check when action in [:leaderboard_weekly, :leaderboard_alltime]

  def index(conn, _params) do
    quiz_sessions = Quizzes.list_quiz_sessions()
    render(conn, "index.json", quiz_sessions: quiz_sessions)
  end

  def create(conn, %{"game" => quiz_session_params}) do
    with {:ok, %QuizSession{} = quiz_session} <- Quizzes.create_quiz_session(quiz_session_params) do
      quiz_session = Quizzes.get_quiz_session!(quiz_session.id)
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

  def now(%Plug.Conn{assigns: %{current_user: user}} = conn,_params) do
    #IO.inspect user
    valid_show = show_hidden_game(user)
    game = Quizzes.get_game_now_status(valid_show)
    render(conn, "now.json", game: game)
  end

  def show_hidden_game(user) do
    cond do
      user == nil -> false # added safeguard if user not defined
      user.role == "admin" ->  true
      user.is_tester == true ->  true
      true -> false
    end
  end

  def leaderboard_weekly(conn,_params) do
    game = Quizzes.list_quiz_scores_weekly()
    render(conn, "leaderboard.json", scores: game)
  end

  def leaderboard_alltime(conn,_params) do
    game = Quizzes.list_quiz_scores_all_time()
    render(conn, "leaderboard.json", scores: game)
  end

end
