defmodule Bijakhq.PushNotifications.ExpoToken do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pn_expo_tokens" do
    field :is_active, :boolean, default: true
    field :platform, :string
    field :token, :string
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(expo_token, attrs) do
    expo_token
    |> cast(attrs, [:token, :platform, :is_active])
    |> validate_required([:token, :platform, :is_active])
  end
end
