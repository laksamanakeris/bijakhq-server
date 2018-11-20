# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

statuses = [
  %{name: "New", description: "New request"},
  %{name: "Processed", description: "Payment request is being processed"},
  %{name: "Pending confirmation", description: "Pending confirmation from Payment Provider"},
  %{name: "Paid", description: "Paid"},
  %{name: "Failed", description: "Payment request failed"}
]

for status <- statuses do
  {:ok, status} = Bijakhq.Payments.create_payment_status(status)
end
