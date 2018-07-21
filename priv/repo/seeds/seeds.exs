# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

users = [
  %{email: "kerismelayu@gmail.com", password: "Bijak@2018", username: "administrator", role: "admin"},
  %{email: "hatta.zainal@gmail.com", password: "Bijak@2018", username: "moderator", role: "admin"}
]

for user <- users do
  {:ok, user} = Bijakhq.Accounts.create_user(user)
  Bijakhq.Accounts.confirm_user(user)
end
