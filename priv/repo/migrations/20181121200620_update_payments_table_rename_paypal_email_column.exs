defmodule Bijakhq.Repo.Migrations.UpdatePaymentsTableRenamePaypalEmailColumn do
  use Ecto.Migration

  def change do

    rename table(:payments), :batch_paypal_email, to: :paypal_email

    alter table(:payments) do
      remove :batch_paypal_id
    end
    
  end
end
