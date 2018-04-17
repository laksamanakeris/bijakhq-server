defmodule Bijakhq.Repo.Migrations.AddPhoneNumberToUserTable do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :username, :string
      add :phone, :string
      add :profile_picture, :string
    end

    create unique_index :users, [:username]
    create unique_index :users, [:phone]
  end
end
