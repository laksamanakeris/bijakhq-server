defmodule Bijakhq.Repo.Migrations.CreateExpoTokens do
  use Ecto.Migration

  def change do
    create table(:pn_expo_tokens) do
      add :token, :string
      add :platform, :string
      add :is_active, :boolean, default: true, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:pn_expo_tokens, [:user_id])
  end
end
