defmodule Bijakhq.Repo.Migrations.CreatePaymentHistory do
  use Ecto.Migration

  def change do
    create table(:payment_history) do
      add :amount, :float
      add :user_id, :integer
      add :payment_at, :utc_datetime
      add :remarks, :text
      add :updated_by, :integer

      timestamps()
    end

  end
end
