defmodule Bijakhq.Repo.Migrations.CreateQuizQuestions do
  use Ecto.Migration

  def change do
    create table(:quiz_questions) do
      add :question, :string
      add :answer, :string
      add :optionB, :string
      add :optionC, :string
      add :category_id, references(:quiz_categories, on_delete: :nothing)

      timestamps()
    end

    create index(:quiz_questions, [:category_id])
  end
end
