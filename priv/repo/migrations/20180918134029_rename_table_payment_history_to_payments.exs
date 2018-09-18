defmodule Bijakhq.Repo.Migrations.RenameTablePaymentHistoryToPayments do
  use Ecto.Migration

  def change do
    rename table(:payment_history), to: table(:payments)
  end
end
