# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# It is also run when you use the command `mix ecto.setup`
#

types = [
  %{name: "Paypal", description: "Description will be here", configuration: "Configurations details will be here"}
]

for type <- types do
  {:ok, type} = Bijakhq.Payments.create_payment_type(type)
end
