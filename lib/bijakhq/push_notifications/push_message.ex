defmodule Bijakhq.PushNotifications.PushMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User


  schema "pn_messages" do
    field :is_completed, :boolean, default: false
    field :message, :string
    field :total_tokens, :integer
    # field :author_id, :id

    belongs_to :user, User, foreign_key: :author_id

    timestamps()
  end

  @doc false
  def changeset(push_message, attrs) do
    push_message
    |> cast(attrs, [:message, :is_completed, :total_tokens, :author_id])
    |> validate_required([:message, :author_id])
  end
end
