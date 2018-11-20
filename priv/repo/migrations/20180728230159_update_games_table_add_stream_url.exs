defmodule Bijakhq.Repo.Migrations.UpdateGamesTableAddStreamUrl do
  use Ecto.Migration

  def change do
    alter table(:quiz_sessions) do
      add :stream_url, :text
    end
  end
end
