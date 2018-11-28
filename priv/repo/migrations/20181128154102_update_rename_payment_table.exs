defmodule Bijakhq.Repo.Migrations.UpdateRenamePaymentTable do
  use Ecto.Migration

  def change do
    rename table(:payments), to: table(:payment_requests)
  end
end
