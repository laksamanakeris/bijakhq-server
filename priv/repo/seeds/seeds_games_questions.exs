# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

alias Bijakhq.{Quizzes, Repo}
alias Bijakhq.Quizzes.QuizQuestion



# for idx <-  1..40 do
#   cat_id = Enum.random(1..4)
#   question = Faker.Lorem.Shakespeare.hamlet
#   answer = Faker.StarWars.character
#   optionB = Faker.StarWars.character
#   optionC = Faker.StarWars.character

#   %{
#     category_id: cat_id,
#     question: question,
#     answer: answer,
#     optionB: optionB,
#     optionC: optionC
#   }
#   |> Quizzes.create_quiz_question
# end

sessions = Quizzes.list_quiz_sessions
# IO.inspect sessions

# Enum.each  sessions,  fn {k} ->
#   # IO.puts "#{k} --> #{v}"
#   IO.puts "--> "
#   # IO.inspect v
# end

Enum.map sessions, fn(game) ->

  IO.puts "========================================================================="
  IO.inspect game

  total_question = game.total_questions

  for idx <-  1..total_question do
    question = Quizzes.get_random_question
    IO.inspect question
    Quizzes.create_session_question( %{session_id: game.id, question_id: question.id})
    Quizzes.update_quiz_question(question, %{selected: true})
  end

  IO.puts "========================================================================="
end
