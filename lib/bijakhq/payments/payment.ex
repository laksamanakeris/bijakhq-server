defmodule Bijakhq.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User
  alias Bijakhq.Payments.PaymentType
  alias Bijakhq.Payments.PaymentStatus


  schema "payments" do
    field :amount, :float
    field :payment_at, :utc_datetime
    field :remarks, :string

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :update_by, User, foreign_key: :updated_by
    belongs_to :status, PaymentStatus, foreign_key: :payment_status
    belongs_to :type, PaymentType, foreign_key: :payment_type

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :user_id, :payment_at, :remarks, :updated_by, :payment_status, :payment_type])
    |> validate_required([:amount, :user_id, :updated_by, :payment_type ])
  end
end
