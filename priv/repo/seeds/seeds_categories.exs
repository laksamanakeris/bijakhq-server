# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

categories = [
  %{title: "Music"},
  %{title: "Nation"},
  %{title: "Education"},
  %{title: "History"}
]

for category <- categories do
  {:ok, category} = Bijakhq.Quizzes.create_quiz_category(category)
end
