defmodule Bijakhq.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Accounts.User
  alias Bijakhq.Quizzes.QuizScore
  use Arc.Ecto.Schema

  schema "users" do
    field :email, :string
    field :username, :string
    field :phone, :string
    field :profile_picture, Bijakhq.ImageFile.Type
    # field :profile_picture, :string
    field :filename, :string, virtual: true

    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmed_at, :utc_datetime
    field :reset_sent_at, :utc_datetime

    field :role, :string, default: "user" # user or admin
    field :is_tester, :boolean, default: false 

    field :country, :string, default: "MY"
    field :language, :string, default: "en"

    field :games_played, :integer, default: 0
    field :has_phone, :boolean, default: false
    field :high_score, :integer, default: 0
    field :lives, :integer, default: 0
    field :referral_url, :string
    field :referred, :boolean, default: false
    # field :referring_user_id, :integer
    field :win_count, :integer, default: 0
    field :verification_id, :string

    field :rank_weekly, :integer
    field :rank_alltime, :integer

    field :paypal_email, :string

    timestamps()

    has_many :scores, QuizScore, foreign_key: :user_id
    belongs_to :referrer, User, foreign_key: :referring_user_id
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :username, :phone, :profile_picture, :confirmed_at, :role, :is_tester, :country, :language, :games_played, :has_phone, :high_score, :lives, :referral_url, :referred, :referring_user_id, :win_count, :verification_id, :rank_weekly, :rank_alltime])
    |> validate_required([:username])
    |> unique_email
    |> unique_username
  end

  def create_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :username, :role])
    |> validate_required([:email, :password])
    |> unique_email
    |> unique_username
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

  @doc false
  def upload_changeset(%User{} = user, attrs) do

    attrs = add_timestamp(attrs)
    user
    |> cast(attrs, [:profile_picture])
    |> cast_attachments(attrs, [:profile_picture])
    |> validate_required([:profile_picture])
  end

  def update_username_changeset(%User{} = user, attrs)do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_username
  end

  def update_paypal_email_changeset(%User{} = user, attrs)do
    user
    |> cast(attrs, [:paypal_email])
    |> validate_required([:paypal_email])
    |> validate_format(:paypal_email, ~r/@/)
    |> validate_length(:paypal_email, max: 254)
  end

  defp unique_username(changeset) do
    validate_length(changeset, :username, min: 3)
    |> unique_constraint(:username)
    |> downcase_username
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

  defp downcase_username(changeset) do
    update_change(changeset, :username, &String.downcase/1)
  end

  defp add_timestamp(%{"profile_picture" => %Plug.Upload{filename: name} = image} = attrs) do
    image = %Plug.Upload{image | filename: prepend_timestamp(name)}
    %{attrs | "profile_picture" => image}
  end

  defp add_timestamp(params), do: params

  defp prepend_timestamp(name) do
    "#{:os.system_time()}" <> name
  end

  defp put_random_filename(%{"profile_picture" => %Plug.Upload{filename: name} = image} = params) do
    image = %Plug.Upload{image | filename: random_filename(name)}
    %{params | "profile_picture" => image}
  end

  defp put_random_filename(params), do: params

  defp random_filename(name) do
    (:crypto.strong_rand_bytes(20) |> Base.url_encode64 |> binary_part(0, 20)) <> name
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
