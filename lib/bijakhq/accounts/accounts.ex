defmodule Bijakhq.Accounts do
  @moduledoc """
  The boundary for the Accounts system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Phauxth.Log
  alias Bijakhq.{Accounts.User, Repo}
  alias Bijakhq.Accounts.Referral

  def list_users do
    Repo.all(User)
  end

  def get(id), do: Repo.get(User, id)

  def get_by(%{"email" => email}) do
    Repo.get_by(User, email: email)
  end

  def get_by(%{"username" => username}) do
    Repo.get_by(User, username: username)
  end

  def get_by(%{"phone" => phone}) do
    Repo.get_by(User, phone: phone)
  end

  def get_user_by_username(username) do
    get_by(%{"username" => username})
  end

  def create_user(attrs) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  def create_new_user(attrs) do
    %User{}
    |> User.create_user_changeset(attrs)
    |> Repo.insert()
  end

  def confirm_user(%User{} = user) do
    change(user, %{confirmed_at: DateTime.utc_now()}) |> Repo.update()
  end

  def create_password_reset(endpoint, attrs) do
    with %User{} = user <- get_by(attrs) do
      change(user, %{reset_sent_at: DateTime.utc_now}) |> Repo.update
      Log.info(%Log{user: user.id, message: "password reset requested"})
      Phauxth.Token.sign(endpoint, attrs)
    end
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def update_username(%User{} = user, attrs) do
    user
    |> User.update_username_changeset(attrs)
    |> Repo.update()
  end

  def upload_image(%User{} = user, attrs) do
    user
    |> User.upload_changeset(attrs)
    |> Repo.update()
  end

  def update_password(%User{} = user, attrs) do
    user
    |> User.create_changeset(attrs)
    |> change(%{reset_sent_at: nil})
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end



  def list_referrals do
    Repo.all(Referral) |> Repo.preload([:user, :referrer])
  end
  def get_referral!(id), do: Repo.get!(Referral, id) |> Repo.preload([:user, :referrer])

  def create_referral(attrs \\ %{}) do
    %Referral{}
    |> Referral.changeset(attrs)
    |> Repo.insert()
  end

  def update_referral(%Referral{} = referral, attrs) do
    referral
    |> Referral.changeset(attrs)
    |> Repo.update()
    |> Repo.preload([:user, :referrer])
  end

  def delete_referral(%Referral{} = referral) do
    Repo.delete(referral)
  end

  def change_referral(%Referral{} = referral) do
    Referral.changeset(referral, %{})
  end
end
