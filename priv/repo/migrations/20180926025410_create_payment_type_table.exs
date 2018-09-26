defmodule Bijakhq.Repo.Migrations.CreatePaymentTypeTable do
  use Ecto.Migration

  def change do

    create table(:payment_types) do
      add :name, :string
      add :description, :string
      add :configuration, :string

      timestamps()
    end

  end
end
