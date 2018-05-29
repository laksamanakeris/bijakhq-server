defmodule BijakhqWeb.Api.QuizQuestionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizQuestionView

  def render("index.json", %{quiz_questions: quiz_questions}) do
    %{data: render_many(quiz_questions, QuizQuestionView, "quiz_question.json")}
  end

  def render("show.json", %{quiz_question: quiz_question}) do
    %{data: render_one(quiz_question, QuizQuestionView, "quiz_question.json")}
  end

  def render("quiz_question.json", %{quiz_question: quiz_question}) do
    %{id: quiz_question.id,
      category_id: quiz_question.category_id,
      question: quiz_question.question,
      answer: quiz_question.answer,
      optionB: quiz_question.optionB,
      optionC: quiz_question.optionC}
  end
end
