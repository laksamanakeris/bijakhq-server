defmodule Bijakhq.Repo.Migrations.UpdatePaymentStatusesSetNameUnique do
  use Ecto.Migration

  def change do
    create unique_index :payment_statuses, [:name]
    create unique_index :payment_types, [:name]
  end
end
