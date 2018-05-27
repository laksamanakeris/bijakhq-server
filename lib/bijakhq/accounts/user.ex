defmodule Bijakhq.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Accounts.User

  schema "users" do
    field :email, :string
    field :username, :string
    field :phone, :string
    field :profile_picture, :string

    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmed_at, :utc_datetime
    field :reset_sent_at, :utc_datetime

    field :role, :string, default: "user"

    field :country, :string, default: "MY"
    field :language, :string, default: "en"

    field :games_played, :integer, default: 0
    field :has_phone, :boolean, default: false
    field :high_score, :integer, default: 0
    field :lives, :integer, default: 0
    field :referral_url, :string
    field :referred, :boolean, default: false
    field :referring_user_id, :integer
    field :win_count, :integer, default: 0
    field :verification_id, :string

    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
    |> unique_email
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username, :role])
    |> validate_required([:email, :password])
    |> unique_email
    |> validate_password(:password)
    |> put_pass_hash
  end

  def create_user_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:phone, :language, :country, :verification_id, :username])
    |> validate_required([:phone, :language, :country, :verification_id, :username])
    |> unique_username
    |> unique_phone
  end

  defp unique_username(changeset) do
    validate_length(changeset, :username, min: 3)
    |> unique_constraint(:username)
  end

  defp unique_phone(changeset) do
    validate_length(changeset, :phone, min: 3)
    |> unique_constraint(:phone)
  end

  defp unique_email(changeset) do
    validate_format(changeset, :email, ~r/@/)
    |> validate_length(:email, max: 254)
    |> unique_constraint(:email)
  end

  # In the function below, strong_password? just checks that the password
  # is at least 8 characters long.
  # See the documentation for NotQwerty123.PasswordStrength.strong_password?
  # for a more comprehensive password strength checker.
  defp validate_password(changeset, field, options \\ []) do
    validate_change(changeset, field, fn _, password ->
      case strong_password?(password) do
        {:ok, _} -> []
        {:error, msg} -> [{field, options[:message] || msg}]
      end
    end)
  end

  # If you are using Argon2 or Pbkdf2, change Bcrypt to Argon2 or Pbkdf2
  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes:
      %{password: password}} = changeset) do
    change(changeset, Comeonin.Bcrypt.add_hash(password))
  end

  defp put_pass_hash(changeset), do: changeset

  defp strong_password?(password) when byte_size(password) > 7 do
    {:ok, password}
  end

  defp strong_password?(_), do: {:error, "The password is too short"}
end
