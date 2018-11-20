defmodule Bijakhq.Repo.Migrations.UpdateBatchTemSetUniqeRecords do
  use Ecto.Migration

  def up do
    create unique_index(:payment_batch_items, [:batch_id, :payment_id], name: :index_batches_payments)
  end
  
  def down do
    drop index(:payment_batch_items, [:batch_id, :payment_id], name: :index_batches_payments)
  end

end
