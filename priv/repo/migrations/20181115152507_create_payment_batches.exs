defmodule Bijakhq.Repo.Migrations.CreatePaymentBatches do
  use Ecto.Migration

  def change do
    create table(:payment_batches) do
      add :date_processed, :utc_datetime
      add :description, :text
      add :is_processed, :boolean, default: false, null: false
      add :generated_request, :json
      timestamps()
    end

  end
end
