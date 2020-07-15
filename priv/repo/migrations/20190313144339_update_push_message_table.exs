defmodule Bijakhq.Repo.Migrations.UpdatePushMessageTable do
  use Ecto.Migration

  def change do

    alter table(:pn_messages) do
      add :title, :string
      add :is_tester, :boolean, default: false, null: false
    end

  end
end
