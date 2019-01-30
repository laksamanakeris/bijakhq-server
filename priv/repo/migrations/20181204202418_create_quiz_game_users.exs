defmodule Bijakhq.Repo.Migrations.CreateQuizGameUsers do
  use Ecto.Migration

  def change do
    create table(:quiz_game_users) do
      add :is_player, :boolean, default: false, null: false
      add :is_viewer, :boolean, default: false, null: false
      add :game_id, references(:quiz_sessions, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:quiz_game_users, [:game_id])
    create index(:quiz_game_users, [:user_id])
  end
end
