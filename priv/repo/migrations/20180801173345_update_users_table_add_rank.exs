defmodule Bijakhq.Repo.Migrations.UpdateUsersTableAddRank do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :rank_weekly, :integer
      add :rank_alltime, :integer
    end
  end
end
