defmodule BijakhqWeb.Api.GameQuestionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.GameQuestionView

  def render("index.json", %{quiz_game_question: quiz_game_question}) do
    %{data: render_many(quiz_game_question, GameQuestionView, "game_question.json")}
  end

  def render("index_preload.json", %{quiz_game_question: quiz_game_question}) do
    %{data: render_many(quiz_game_question, GameQuestionView, "question_index_preload.json")}
  end

  def render("show.json", %{game_question: game_question}) do
    %{data: render_one(game_question, GameQuestionView, "game_question.json")}
  end

  def render("show_preload.json", %{game_question: game_question}) do
    %{data: render_one(game_question, GameQuestionView, "question_index_preload.json")}
  end

  def render("game_question.json", %{game_question: game_question}) do

    %{id: game_question.id,
      sequence: game_question.sequence,
      is_completed: game_question.is_completed,
      total_correct: game_question.total_correct}
  end

  def render("game_start_question.json", %{game_question: game_question}) do
    %{
      id: game_question.id,
      sequence: game_question.sequence,
      is_completed: game_question.is_completed,
      total_correct: game_question.total_correct,
      answers_sequence: game_question.answers_sequence,
      answers_totals: game_question.answers_totals
    }
  end

  def render("question.json", %{game_question: game_question}) do
    %{
      id: game_question.id,
      sequence: game_question.sequence,
      is_completed: game_question.is_completed,
      total_correct: game_question.total_correct,
      answers_sequence: game_question.answers_sequence,
      answers_totals: game_question.answers_totals,
      question: render_one(game_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json")
    }
  end

  def render("question_index_preload.json", %{game_question: game_question}) do
    %{
      id: game_question.id,
      sequence: game_question.sequence,
      is_completed: game_question.is_completed,
      total_correct: game_question.total_correct,
      answers_sequence: game_question.answers_sequence,
      answers_totals: game_question.answers_totals,
      question_id: game_question.question_id,
      question: render_one(game_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json")
    }
  end

  def render("question_preload.json", %{game_question: game_question}) do
    %{
      id: game_question.id,
      sequence: game_question.sequence,
      is_completed: game_question.is_completed,
      total_correct: game_question.total_correct,
      answers_sequence: game_question.answers_sequence,
      answers_totals: game_question.answers_totals,
      question_id: game_question.question_id,
      question: render_one(game_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json"),
      session: render_one(game_question.session, BijakhqWeb.Api.QuizSessionView, "quiz_session.json")
    }
  end
end
