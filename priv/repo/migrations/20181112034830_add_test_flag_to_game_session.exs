defmodule Bijakhq.Repo.Migrations.AddTestFlagToGameSession do
  use Ecto.Migration

  def change do
    alter table(:quiz_sessions) do
      add :is_hidden, :boolean, default: false
    end
  end
end
