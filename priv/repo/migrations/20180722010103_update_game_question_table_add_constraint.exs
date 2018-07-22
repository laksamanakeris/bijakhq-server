defmodule Bijakhq.Repo.Migrations.UpdateGameQuestionTableAddConstraint do
  use Ecto.Migration

  def change do
    create unique_index(:quiz_session_question, [:session_id, :question_id], name: :game_question_unique)
  end
end
