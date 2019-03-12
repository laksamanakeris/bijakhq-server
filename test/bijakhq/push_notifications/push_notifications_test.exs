defmodule Bijakhq.PushNotificationsTest do
  use Bijakhq.DataCase

  alias Bijakhq.PushNotifications

  describe "expo_tokens" do
    alias Bijakhq.PushNotifications.ExpoToken

    @valid_attrs %{is_active: true, platform: "some platform", token: "some token"}
    @update_attrs %{is_active: false, platform: "some updated platform", token: "some updated token"}
    @invalid_attrs %{is_active: nil, platform: nil, token: nil}

    def expo_token_fixture(attrs \\ %{}) do
      {:ok, expo_token} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PushNotifications.create_expo_token()

      expo_token
    end

    test "list_expo_tokens/0 returns all expo_tokens" do
      expo_token = expo_token_fixture()
      assert PushNotifications.list_expo_tokens() == [expo_token]
    end

    test "get_expo_token!/1 returns the expo_token with given id" do
      expo_token = expo_token_fixture()
      assert PushNotifications.get_expo_token!(expo_token.id) == expo_token
    end

    test "create_expo_token/1 with valid data creates a expo_token" do
      assert {:ok, %ExpoToken{} = expo_token} = PushNotifications.create_expo_token(@valid_attrs)
      assert expo_token.is_active == true
      assert expo_token.platform == "some platform"
      assert expo_token.token == "some token"
    end

    test "create_expo_token/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PushNotifications.create_expo_token(@invalid_attrs)
    end

    test "update_expo_token/2 with valid data updates the expo_token" do
      expo_token = expo_token_fixture()
      assert {:ok, expo_token} = PushNotifications.update_expo_token(expo_token, @update_attrs)
      assert %ExpoToken{} = expo_token
      assert expo_token.is_active == false
      assert expo_token.platform == "some updated platform"
      assert expo_token.token == "some updated token"
    end

    test "update_expo_token/2 with invalid data returns error changeset" do
      expo_token = expo_token_fixture()
      assert {:error, %Ecto.Changeset{}} = PushNotifications.update_expo_token(expo_token, @invalid_attrs)
      assert expo_token == PushNotifications.get_expo_token!(expo_token.id)
    end

    test "delete_expo_token/1 deletes the expo_token" do
      expo_token = expo_token_fixture()
      assert {:ok, %ExpoToken{}} = PushNotifications.delete_expo_token(expo_token)
      assert_raise Ecto.NoResultsError, fn -> PushNotifications.get_expo_token!(expo_token.id) end
    end

    test "change_expo_token/1 returns a expo_token changeset" do
      expo_token = expo_token_fixture()
      assert %Ecto.Changeset{} = PushNotifications.change_expo_token(expo_token)
    end
  end
end
