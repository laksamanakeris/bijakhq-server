defmodule Bijakhq.Repo.Migrations.UpdateBatchTable do
  use Ecto.Migration

  def change do
    alter table(:payment_batches) do
      add :payout_batch_id, :string
      add :batch_status, :string
    end
  end
end
