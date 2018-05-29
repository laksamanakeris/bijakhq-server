defmodule Bijakhq.Repo.Migrations.CreateQuizCategories do
  use Ecto.Migration

  def change do
    create table(:quiz_categories) do
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
