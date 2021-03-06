defmodule BijakhqWeb.Api.QuizQuestionView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizQuestionView

  def render("index.json", %{quiz_questions: quiz_questions}) do
    %{data: render_many(quiz_questions, QuizQuestionView, "quiz_question.json"),
      page_number: quiz_questions.page_number, 
      page_size: quiz_questions.page_size,
      total_pages: quiz_questions.total_pages,
      total_entries: quiz_questions.total_entries
    }
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
      optionC: quiz_question.optionC,
      description: quiz_question.description,
      games: render_many(quiz_question.games, BijakhqWeb.Api.QuizQuestionView , "game.json"),
    }
  end

  def render("soalan.json", %{quiz_question: quiz_question}) do
    %{
      game_question_id: quiz_question.id,
      question: quiz_question.answers_sequence.question,
      answers: render_many(quiz_question.answers_sequence.answers, BijakhqWeb.Api.QuizQuestionView , "jawapan.json"),
      question_id: quiz_question.question_id,
      game_id: quiz_question.session_id,
    }
  end

  def render("soalan_details.json", %{quiz_question: quiz_question}) do
    %{
      game_question_id: quiz_question.id,
      question: quiz_question.answers_sequence.question,
      answers: render_many(quiz_question.answers_sequence.answers, BijakhqWeb.Api.QuizQuestionView , "jawapan.json"),
      question_id: quiz_question.question_id,
      game_id: quiz_question.session_id,
      description: quiz_question.description,
    }
  end

  def render("game.json", %{quiz_question: game}) do

    %{
      game_id: game.id,
      name: game.name,
      description: game.description,
      time: game.time,
      is_completed: game.is_completed,
      completed_at: game.completed_at,
    }
  end

  def render("jawapan.json", %{quiz_question: jawapan}) do

    %{
      id: jawapan.id,
      text: jawapan.text
    }
  end


  def render("soalan_jawapan.json", %{quiz_question: quiz_question}) do

    %{
      game_question_id: quiz_question.id,
      description: quiz_question.answers_sequence.description,
      question: quiz_question.answers_sequence.question,
      answers: render_many(quiz_question.answers_sequence.answers, BijakhqWeb.Api.QuizQuestionView , "jawapan_full.json"),
      question_id: quiz_question.question_id,
      game_id: quiz_question.session_id
    }
  end

  def render("jawapan_full.json", %{quiz_question: jawapan}) do

    %{
      id: jawapan.id,
      text: jawapan.text,
      answer: jawapan.answer,
      total_answered: jawapan.total_answered
    }
  end

end
