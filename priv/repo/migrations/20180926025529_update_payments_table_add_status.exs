defmodule Bijakhq.Repo.Migrations.UpdatePaymentsTableAddStatus do
  use Ecto.Migration

  def change do

    alter table(:payments) do
      add :paymemt_status_id, references(:payment_statuses), default: 1
    end

  end
end
