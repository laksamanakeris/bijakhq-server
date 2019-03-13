defmodule Bijakhq.PushNotifications.PushMessage do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Accounts.User


  schema "pn_messages" do
    field :is_completed, :boolean, default: false
    field :is_tester, :boolean, default: false
    field :message, :string
    field :title, :string
    field :total_tokens, :integer
    # field :author_id, :id

    belongs_to :user, User, foreign_key: :author_id

    timestamps()
  end

  @doc false
  def changeset(push_message, attrs) do
    push_message
    |> cast(attrs, [:title, :message, :is_completed, :is_tester, :total_tokens, :author_id])
    |> validate_required([:title, :message, :author_id])
  end
end
