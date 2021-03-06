defmodule Bijakhq.Sms.NexmoRequest do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Sms.NexmoRequest

  schema "nexmo_request" do
    field :completed_at, :utc_datetime
    field :is_completed, :boolean, default: false
    field :phone, :string
    field :request_id, :string
    field :verified_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(%NexmoRequest{} = nexmo_request, attrs) do
    nexmo_request
    |> cast(attrs, [:phone, :request_id, :is_completed, :verified_at, :completed_at])
    |> validate_required([:phone, :request_id])
  end

  def create_changeset(%NexmoRequest{} = nexmo_request, attrs) do
    nexmo_request
    |> cast(attrs, [:phone, :request_id])
    |> validate_required([:phone, :request_id])
  end
end
