defmodule Bijakhq.Repo.Migrations.UpdateQuestionsTable do
  use Ecto.Migration

  def change do
    alter table(:quiz_questions) do
      add :selected, :boolean, default: false
    end
  end
end
