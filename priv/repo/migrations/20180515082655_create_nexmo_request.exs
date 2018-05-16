defmodule Bijakhq.Repo.Migrations.CreateNexmoRequest do
  use Ecto.Migration

  def change do
    create table(:nexmo_request) do
      add :phone, :string
      add :verification_id, :string
      add :is_completed, :boolean, default: false, null: false
      add :verified_at, :date
      add :completed_at, :date

      timestamps()
    end

  end
end
