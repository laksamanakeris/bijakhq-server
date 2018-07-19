defmodule BijakhqWeb.Api.SessionQuestionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.SessionQuestionView

  def render("index.json", %{quiz_session_question: quiz_session_question}) do
    %{data: render_many(quiz_session_question, SessionQuestionView, "session_question.json")}
  end

  def render("show.json", %{session_question: session_question}) do
    %{data: render_one(session_question, SessionQuestionView, "session_question.json")}
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
      question: render_one(session_question.question, BijakhqWeb.Api.QuizQuestionView, "quiz_question.json")
    }
  end
end
