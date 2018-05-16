defmodule Bijakhq.Repo.Migrations.CreatePhoneVerifications do
  use Ecto.Migration

  def change do
    create table(:phone_verifications) do
      add :phone, :string
      add :verification_id, :string
      add :is_completed, :boolean, default: false, null: false
      add :verified_at, :date
      add :completed_at, :date

      timestamps()
    end

  end
end
