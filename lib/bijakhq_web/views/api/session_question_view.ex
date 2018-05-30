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
      total_answered_a: session_question.total_answered_a,
      total_answered_b: session_question.total_answered_b,
      total_answered_c: session_question.total_answered_c,
      total_correct: session_question.total_correct}
  end
end
