defmodule Bijakhq.Repo.Migrations.CreatePaymentStatusTable do
  use Ecto.Migration

  def change do

    create table(:payment_statuses) do
      add :name, :string
      add :description, :string

      timestamps()
    end

  end
end
