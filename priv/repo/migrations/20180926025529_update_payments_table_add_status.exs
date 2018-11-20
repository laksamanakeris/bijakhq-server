defmodule Bijakhq.Repo.Migrations.UpdatePaymentsTableAddStatus do
  use Ecto.Migration

  def change do

    alter table(:payments) do
      add :paymemt_status, references(:payment_statuses), default: 1
      add :payment_type, references(:payment_types)
      add :reference_id, :string
      add :reference_details, :text
      add :batch_paypal_email, :string  # Put it here for temporary
      add :batch_paypal_id, :integer  # Put it here for temporary
    end

  end
end
