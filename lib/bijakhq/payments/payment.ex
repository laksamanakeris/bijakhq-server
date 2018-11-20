defmodule Bijakhq.Payments.Payment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User
  alias Bijakhq.Payments.PaymentType
  alias Bijakhq.Payments.PaymentBatch
  alias Bijakhq.Payments.PaymentStatus
  alias Bijakhq.Payments.PaymentBatchItem


  schema "payments" do
    field :amount, :float
    field :payment_at, :utc_datetime
    field :remarks, :string

    field :reference_id, :string
    field :reference_details, :string
    field :batch_paypal_email, :string
    field :batch_paypal_id, :integer

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :update_by, User, foreign_key: :updated_by
    belongs_to :status, PaymentStatus, foreign_key: :payment_status
    belongs_to :type, PaymentType, foreign_key: :payment_type

    has_many :batch_items, PaymentBatchItem, foreign_key: :payment_id
    # Payment can have many batches - this will happen when there's issue processing the Paypal Payment 
    many_to_many :batches, PaymentBatch, join_through: "payment_batch_items", join_keys: [batch_id: :id, payment_id: :id]

    timestamps()
  end

  @doc false
  def changeset(payment, attrs) do
    payment
    |> cast(attrs, [:amount, :user_id, :payment_at, :remarks, :updated_by, :payment_status, :payment_type])
    |> validate_required([:amount, :user_id, :updated_by, :payment_type ])
  end
end
