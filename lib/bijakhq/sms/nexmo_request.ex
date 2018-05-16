defmodule Bijakhq.Sms.NexmoRequest do
  use Ecto.Schema
  import Ecto.Changeset


  schema "nexmo_request" do
    field :completed_at, :date
    field :is_completed, :boolean, default: false
    field :phone, :string
    field :verification_id, :string
    field :verified_at, :date

    timestamps()
  end

  @doc false
  def changeset(nexmo_request, attrs) do
    nexmo_request
    |> cast(attrs, [:phone, :verification_id, :is_completed, :verified_at, :completed_at])
    |> validate_required([:phone, :verification_id, :is_completed, :verified_at, :completed_at])
  end
end
