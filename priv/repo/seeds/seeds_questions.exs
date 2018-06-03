# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

alias Bijakhq.{Quizzes, Repo}
alias Bijakhq.Quizzes.QuizQuestion


for idx <-  1..40 do
  cat_id = Enum.random(1..4)
  question = Faker.Lorem.Shakespeare.hamlet
  answer = Faker.StarWars.character
  optionB = Faker.StarWars.character
  optionC = Faker.StarWars.character

  %{
    category_id: cat_id,
    question: question,
    answer: answer,
    optionB: optionB,
    optionC: optionC
  }
  |> Quizzes.create_quiz_question
end
