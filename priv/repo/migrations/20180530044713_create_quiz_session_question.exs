defmodule Bijakhq.Repo.Migrations.CreateQuizSessionQuestion do
  use Ecto.Migration

  def change do
    create table(:quiz_session_question) do
      add :sequence, :integer
      add :is_completed, :boolean, default: false, null: false
      add :total_answered_a, :integer
      add :total_answered_b, :integer
      add :total_answered_c, :integer
      add :total_correct, :integer
      add :session_id, references(:quiz_sessions, on_delete: :nothing)
      add :question_id, references(:quiz_questions, on_delete: :nothing)

      timestamps()
    end

    create index(:quiz_session_question, [:session_id])
    create index(:quiz_session_question, [:question_id])
  end
end
