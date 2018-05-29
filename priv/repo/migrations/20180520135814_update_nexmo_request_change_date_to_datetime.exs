defmodule Bijakhq.Repo.Migrations.UpdateNexmoRequestChangeDateToDatetime do
  use Ecto.Migration

  def change do

    alter table(:nexmo_request) do
      modify :verified_at, :utc_datetime
      modify :completed_at, :utc_datetime
    end

  end
end
