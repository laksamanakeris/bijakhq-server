defmodule Bijakhq.Repo.Migrations.CreatePaymentBatches do
  use Ecto.Migration

  def change do
    create table(:payment_batches) do
      add :date_processed, :naive_datetime
      add :description, :string
      add :is_processed, :boolean, default: false, null: false

      timestamps()
    end

  end
end
