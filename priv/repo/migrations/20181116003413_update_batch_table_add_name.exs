defmodule Bijakhq.Repo.Migrations.UpdateBatchTableAddName do
  use Ecto.Migration

  def change do

    alter table(:payment_batches) do
      add :name, :string
    end

  end
end
