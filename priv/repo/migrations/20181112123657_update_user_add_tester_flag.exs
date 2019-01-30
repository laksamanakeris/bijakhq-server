defmodule Bijakhq.Repo.Migrations.UpdateUserAddTesterFlag do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :is_tester, :boolean, default: false
    end
  end
end
