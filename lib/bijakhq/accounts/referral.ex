defmodule Bijakhq.Accounts.Referral do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User

  schema "referrals" do
    # field :referred_by, :integer
    field :remarks, :string
    # field :user_id, :integer

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :referrer, User, foreign_key: :referred_by

    timestamps()
  end

  @doc false
  def changeset(referral, attrs) do
    referral
    |> cast(attrs, [:user_id, :referred_by, :remarks])
    |> validate_required([:user_id, :referred_by])
  end


end
