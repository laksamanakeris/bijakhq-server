defmodule Bijakhq.Repo.Migrations.AddIndexToIsDeleted do
  use Ecto.Migration

  def change do
    create index(:quiz_sessions, [:is_deleted])
    create index(:quiz_questions, [:is_deleted])
    create index(:users, [:is_deleted])
  end
end
