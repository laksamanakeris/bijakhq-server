defmodule Bijakhq.Repo.Migrations.CreateScoresTable do
  use Ecto.Migration

  def change do
    create table(:quiz_scores) do

      add :amount, :float

      add :user_id, references(:users, on_delete: :nothing), null: false
      add :game_id, references(:quiz_sessions, on_delete: :nothing), null: false
      add :completed_at, :utc_datetime

      timestamps()
    end

  end
end
