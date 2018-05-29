defmodule Bijakhq.Repo.Migrations.UpdateNexmoRequestTable do
  use Ecto.Migration

  def change do
    rename table(:nexmo_request), :verification_id, to: :request_id
  end
end
