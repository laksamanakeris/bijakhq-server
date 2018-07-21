defmodule Bijakhq.Repo.Migrations.UpdateQuizSessionTableModifyPrizeType do
  use Ecto.Migration

  def change do

    alter table(:quiz_sessions) do
      remove :prize
      add :prize, :integer
    end

  end
end
