defmodule Bijakhq.Repo.Migrations.CreatePaymentBatchItems do
  use Ecto.Migration

  def change do
    create table(:payment_batch_items) do
      add :batch_id, references(:payment_batches, on_delete: :nothing), primary_key: true
      add :payment_id, references(:payments, on_delete: :nothing), primary_key: true
      add :status, :integer

      timestamps()
    end

  end
end
