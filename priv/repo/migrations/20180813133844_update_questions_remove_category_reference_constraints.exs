defmodule Bijakhq.Repo.Migrations.UpdateQuestionsRemoveCategoryReferenceConstraints do
  use Ecto.Migration

  def up do
    drop constraint(:quiz_questions, "quiz_questions_category_id_fkey")
    alter table(:quiz_questions) do
      modify(:category_id, references(:quiz_categories, on_delete: :nilify_all))
    end
  end

  def down do
    drop constraint(:quiz_questions, "quiz_questions_category_id_fkey")
    alter table(:quiz_questions) do
      modify(:category_id, references(:quiz_categories, on_delete: :nothing))
    end
  end
end
