defmodule Bijakhq.Repo.Migrations.UpdateQuizCategoryTableSetUniqueTitle do
  use Ecto.Migration

  def change do
    create unique_index :quiz_categories, [:title]
  end
end
