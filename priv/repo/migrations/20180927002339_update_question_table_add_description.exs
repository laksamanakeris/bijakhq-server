defmodule Bijakhq.Repo.Migrations.UpdateQuestionTableAddDescription do
  use Ecto.Migration

  def change do

    alter table(:quiz_questions) do
      add :description, :text
    end

  end
end
