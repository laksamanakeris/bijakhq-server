defmodule Bijakhq.Repo.Migrations.UpdatePaymentsTableChangePaymentStatusColumnName do
  use Ecto.Migration

  def change do
    rename table(:payments), :paymemt_status, to: :payment_status
  end
end
