# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

alias Bijakhq.{Quizzes, Repo}
alias Bijakhq.Quizzes.QuizQuestion


for idx <-  2..5 do
  name = "Game #{idx}"
  prize = 5000
  total_questions = 5
  description = "Testing Game #{idx}"
  time = "2018-06-1#{idx} 00:00:00"

  %{
    name: name,
    prize: prize,
    total_questions: total_questions,
    description: description,
    time: time
  }
  |> Quizzes.create_quiz_session
end
