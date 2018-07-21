defmodule Bijakhq.Repo.Migrations.UpdateQuizSessionQuestion do
  use Ecto.Migration

  def change do
    alter table(:quiz_session_question) do
      remove :sequence_answer_a
      remove :sequence_answer_b
      remove :sequence_answer_c

      remove :total_answered_a
      remove :total_answered_b
      remove :total_answered_c

      add :answers_sequence, :map, default: "{}"
      add :answers_totals, :map, default: "{}"
    end
  end
end
