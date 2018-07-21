defmodule Bijakhq.Repo.Migrations.CreateQuizSession do
  use Ecto.Migration

  def change do
    create table(:quiz_sessions) do
      add :name, :string
      add :description, :string
      add :prize, :string
      add :prize_description, :string
      add :total_questions, :integer, default: 0
      add :time, :utc_datetime
      add :is_active, :boolean, default: false, null: false
      add :is_completed, :boolean, default: false, null: false
      add :completed_at, :utc_datetime

      timestamps()
    end
  end
end
