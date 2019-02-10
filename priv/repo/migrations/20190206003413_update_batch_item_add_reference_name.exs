defmodule Bijakhq.Repo.Migrations.UpdateBatchTableAddName do
  use Ecto.Migration

  def change do

    alter table(:payment_batch_items) do
      add :ref_id, :string
    end

  end
end
