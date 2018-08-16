defmodule Bijakhq.Repo.Migrations.CreateReferralTable do
  use Ecto.Migration

  def change do
    create table(:referrals) do
      add :user_id, :integer
      add :referred_by, :integer
      add :remarks, :text
      timestamps()
    end
  end
end
