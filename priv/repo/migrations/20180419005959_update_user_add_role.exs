defmodule Bijakhq.Repo.Migrations.UpdateUserAddRole do
  use Ecto.Migration

  def change do

    alter table("users") do
      add :roles, :string, default: "user"
    end

  end
end
