defmodule Bijakhq.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User


  schema "payments" do
    field :amount, :float
    field :payment_at, :utc_datetime
    field :remarks, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :update_by, User, foreign_key: :updated_by

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :user_id, :payment_at, :remarks, :updated_by])
    |> validate_required([:amount, :user_id, :updated_by])
  end
end
