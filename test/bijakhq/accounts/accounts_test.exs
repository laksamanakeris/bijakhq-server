defmodule Bijakhq.AccountsTest do
  use Bijakhq.DataCase

  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.User

  @create_attrs %{email: "fred@example.com", password: "reallyHard2gue$$"}
  @update_attrs %{email: "frederick@example.com"}
  @invalid_attrs %{email: "", password: ""}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Accounts.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Accounts.list_users() == [user]
  end

  test "get returns the user with given id" do
    user = fixture(:user)
    assert Accounts.get(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Accounts.create_user(@create_attrs)
    assert user.email == "fred@example.com"
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
    assert %User{} = user
    assert user.email == "frederick@example.com"
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
    assert user == Accounts.get(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Accounts.delete_user(user)
    refute Accounts.get(user.id)
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Accounts.change_user(user)
  end

  test "update password changes the stored hash" do
    %{password_hash: stored_hash} = user = fixture(:user)
    attrs = %{password: "CN8W6kpb"}
    {:ok, %{password_hash: hash}} = Accounts.update_password(user, attrs)
    assert hash != stored_hash
  end

  test "update_password with weak password fails" do
    user = fixture(:user)
    attrs = %{password: "pass"}
    assert {:error, %Ecto.Changeset{}} = Accounts.update_password(user, attrs)
  end

  describe "referrals" do
    alias Bijakhq.Accounts.Referral

    @valid_attrs %{referred_by: 42, remarks: "some remarks", user_id: 42}
    @update_attrs %{referred_by: 43, remarks: "some updated remarks", user_id: 43}
    @invalid_attrs %{referred_by: nil, remarks: nil, user_id: nil}

    def referral_fixture(attrs \\ %{}) do
      {:ok, referral} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_referral()

      referral
    end

    test "list_referrals/0 returns all referrals" do
      referral = referral_fixture()
      assert Accounts.list_referrals() == [referral]
    end

    test "get_referral!/1 returns the referral with given id" do
      referral = referral_fixture()
      assert Accounts.get_referral!(referral.id) == referral
    end

    test "create_referral/1 with valid data creates a referral" do
      assert {:ok, %Referral{} = referral} = Accounts.create_referral(@valid_attrs)
      assert referral.referred_by == 42
      assert referral.remarks == "some remarks"
      assert referral.user_id == 42
    end

    test "create_referral/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_referral(@invalid_attrs)
    end

    test "update_referral/2 with valid data updates the referral" do
      referral = referral_fixture()
      assert {:ok, referral} = Accounts.update_referral(referral, @update_attrs)
      assert %Referral{} = referral
      assert referral.referred_by == 43
      assert referral.remarks == "some updated remarks"
      assert referral.user_id == 43
    end

    test "update_referral/2 with invalid data returns error changeset" do
      referral = referral_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_referral(referral, @invalid_attrs)
      assert referral == Accounts.get_referral!(referral.id)
    end

    test "delete_referral/1 deletes the referral" do
      referral = referral_fixture()
      assert {:ok, %Referral{}} = Accounts.delete_referral(referral)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_referral!(referral.id) end
    end

    test "change_referral/1 returns a referral changeset" do
      referral = referral_fixture()
      assert %Ecto.Changeset{} = Accounts.change_referral(referral)
    end
  end
end
