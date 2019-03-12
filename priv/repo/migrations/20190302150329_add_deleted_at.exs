defmodule Bijakhq.Repo.Migrations.AddIsDeletedToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :deleted_at, :utc_datetime
    end
    alter table(:quiz_sessions) do
      add :deleted_at, :utc_datetime
    end
    alter table(:quiz_questions) do
      add :deleted_at, :utc_datetime
    end
    
    create index(:quiz_sessions, [:deleted_at])
    create index(:quiz_questions, [:deleted_at])
    create index(:users, [:deleted_at])
  end
end
