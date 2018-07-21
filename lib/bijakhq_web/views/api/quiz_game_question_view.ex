defmodule BijakhqWeb.Api.QuizGameQuestionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizGameQuestionView

  def render("index.json", %{quiz_session_question: quiz_session_question}) do
    %{data: render_many(quiz_session_question, QuizGameQuestionView, "session_question.json")}
  end

  def render("show.json", %{session_question: session_question}) do
    %{data: render_one(session_question, QuizGameQuestionView, "session_question.json")}
  end

  def render("session_question.json", %{session_question: session_question}) do
    %{id: session_question.id,
      sequence: session_question.sequence,
      is_completed: session_question.is_completed,
      total_correct: session_question.total_correct}
  end

  def render("question.json", %{session_question: session_question}) do
    %{
      id: session_question.id,
      sequence: session_question.sequence,
      is_completed: session_question.is_completed,
      total_correct: session_question.total_correct,
      answers_sequence: session_question.answers_sequence,
      answers_totals: session_question.answers_totals,
      question: render_one(session_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json")
    }
  end

  def render("question_preload.json", %{session_question: session_question}) do
    %{
      id: session_question.id,
      sequence: session_question.sequence,
      is_completed: session_question.is_completed,
      total_correct: session_question.total_correct,
      answers_sequence: session_question.answers_sequence,
      answers_totals: session_question.answers_totals,
      question: render_one(session_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json"),
      session: render_one(session_question.session, BijakhqWeb.Api.QuizSessionView, "quiz_session.json")
    }
  end
end
