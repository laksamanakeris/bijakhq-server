defmodule Bijakhq.Repo.Migrations.AddIsDeletedToQuizSessionQuestions do
  use Ecto.Migration

  def change do
    alter table(:quiz_sessions) do
      add :is_deleted, :boolean, default: false
    end
    alter table(:quiz_questions) do
      add :is_deleted, :boolean, default: false
    end
  end
end
