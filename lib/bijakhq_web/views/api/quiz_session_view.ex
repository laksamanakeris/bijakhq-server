defmodule BijakhqWeb.Api.QuizSessionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizSessionView

  def render("index.json", %{quiz_sessions: quiz_sessions}) do
    %{data: render_many(quiz_sessions, QuizSessionView, "quiz_session.json")}
  end

  def render("show.json", %{quiz_session: quiz_session}) do
    %{data: render_one(quiz_session, QuizSessionView, "quiz_session.json")}
  end

  def render("quiz_session.json", %{quiz_session: quiz_session}) do

    questions_count = Enum.count(quiz_session.game_questions)
    IO.inspect questions_count

    %{id: quiz_session.id,
      name: quiz_session.name,
      description: quiz_session.description,
      prize: quiz_session.prize,
      prize_description: quiz_session.prize_description,
      total_questions: questions_count,
      time: quiz_session.time,
      is_active: quiz_session.is_active,
      is_completed: quiz_session.is_completed,
      completed_at: quiz_session.completed_at}
  end

  def render("game_details.json", %{quiz_session: quiz_session}) do
    %{
      game_id: quiz_session.id,
      name: quiz_session.name,
      description: quiz_session.description,
      prize: quiz_session.prize,
      prize_description: quiz_session.prize_description,
      time: quiz_session.time,
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
    %{
      data: %{
          current: render_one(current, QuizSessionView, "game_details.json"),
          upcoming: render_many(upcoming, QuizSessionView, "game_details.json")
      }
    }
  end
end
