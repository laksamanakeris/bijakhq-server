defmodule BijakhqWeb.Api.QuizSessionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizSessionView
  alias Bijakhq.Game.Server
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{quiz_sessions: quiz_sessions}) do
    %{data: render_many(quiz_sessions, QuizSessionView, "quiz_session.json")}
  end

  def render("show.json", %{quiz_session: quiz_session}) do
    %{data: render_one(quiz_session, QuizSessionView, "quiz_session.json")}
  end

  def render("quiz_session.json", %{quiz_session: quiz_session}) do

    questions_count = Enum.count(quiz_session.game_questions)
    #IO.inspect questions_count

    %{id: quiz_session.id,
      name: quiz_session.name,
      description: quiz_session.description,
      prize: quiz_session.prize,
      prize_description: quiz_session.prize_description,
      total_questions: questions_count,
      time: quiz_session.time,
      is_active: quiz_session.is_active,
      is_hidden: quiz_session.is_hidden,
      is_completed: quiz_session.is_completed,
      stream_url: quiz_session.stream_url,
      completed_at: quiz_session.completed_at}
  end

  def render("game_start_details.json", %{quiz_session: quiz_session}) do

    %{
      session_id: quiz_session.session_id,
      total_questions: quiz_session.total_questions,
      current_question: quiz_session.current_question,
      questions: render_many(quiz_session.questions, BijakhqWeb.Api.GameQuestionView, "game_start_question.json"),
      prize: quiz_session.prize,
      prize_text: quiz_session.prize_text
    }
  end

  def render("game_details.json", %{quiz_session: quiz_session}) do
    %{
      game_id: quiz_session.id,
      name: quiz_session.name,
      description: quiz_session.description,
      prize: quiz_session.prize,
      prize_description: quiz_session.prize_description,
      time: quiz_session.time,
      stream_url: quiz_session.stream_url
    }
  end

  def render("game_current.json", %{quiz_session: quiz_session}) do
    %{
      game_id: quiz_session.id,
      name: quiz_session.name,
      description: quiz_session.description,
      prize: quiz_session.prize,
      prize_description: quiz_session.prize_description,
      time: quiz_session.time,
      stream_url: quiz_session.stream_url,
      game_started: quiz_session.game_started
    }
  end


  def render("game_question.json", %{game_question: game_question}) do
    %{data: render_many(game_question, BijakhqWeb.Api.GameQuestionView, "question.json")}
  end

  def render("session_question_show.json", %{game_question: game_question}) do
    %{data: render_one(game_question, BijakhqWeb.Api.GameQuestionView, "question_preload.json")}
  end

  def render("now.json", %{game: game}) do
    %{ current: current, upcoming: upcoming} = game

    # if current != nil do
    #   game_state = Server.get_game_state;
    #   %{game_started: game_started} = game_state
    #   current = Map.put(current, :game_started, game_started)
    # end

    current =
      case current do
          nil   -> current
          _ ->
            game_started = Server.lookup(:game_started)
            case game_started do
              nil -> Map.put(current, :game_started, false)
              _ -> Map.put(current, :game_started, game_started)
            end
      end
    %{
      data: %{
          current: render_one(current, QuizSessionView, "game_current.json"),
          upcoming: render_many(upcoming, QuizSessionView, "game_details.json")
      }
    }
  end

  #  leaderboard
  def render("leaderboard.json", %{scores: scores}) do
    %{data: render_many(scores, QuizSessionView, "score.json")}
  end

  def render("score.json", %{quiz_session: quiz_session}) do
    %{
      amounts: quiz_session.amounts,
      username: quiz_session.user.username,
      user_id: quiz_session.user.id,
      profile_picture: UserView.check_profile_picture(quiz_session.user.profile_picture)
    }
  end

end
