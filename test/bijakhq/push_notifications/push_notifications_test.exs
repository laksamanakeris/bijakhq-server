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

  describe "push_messages" do
    alias Bijakhq.PushNotifications.PushMessage

    @valid_attrs %{is_completed: true, messages: "some messages", total_tokens: 42}
    @update_attrs %{is_completed: false, messages: "some updated messages", total_tokens: 43}
    @invalid_attrs %{is_completed: nil, messages: nil, total_tokens: nil}

    def push_message_fixture(attrs \\ %{}) do
      {:ok, push_message} =
        attrs
        |> Enum.into(@valid_attrs)
        |> PushNotifications.create_push_message()

      push_message
    end

    test "list_push_messages/0 returns all push_messages" do
      push_message = push_message_fixture()
      assert PushNotifications.list_push_messages() == [push_message]
    end

    test "get_push_message!/1 returns the push_message with given id" do
      push_message = push_message_fixture()
      assert PushNotifications.get_push_message!(push_message.id) == push_message
    end

    test "create_push_message/1 with valid data creates a push_message" do
      assert {:ok, %PushMessage{} = push_message} = PushNotifications.create_push_message(@valid_attrs)
      assert push_message.is_completed == true
      assert push_message.messages == "some messages"
      assert push_message.total_tokens == 42
    end

    test "create_push_message/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PushNotifications.create_push_message(@invalid_attrs)
    end

    test "update_push_message/2 with valid data updates the push_message" do
      push_message = push_message_fixture()
      assert {:ok, push_message} = PushNotifications.update_push_message(push_message, @update_attrs)
      assert %PushMessage{} = push_message
      assert push_message.is_completed == false
      assert push_message.messages == "some updated messages"
      assert push_message.total_tokens == 43
    end

    test "update_push_message/2 with invalid data returns error changeset" do
      push_message = push_message_fixture()
      assert {:error, %Ecto.Changeset{}} = PushNotifications.update_push_message(push_message, @invalid_attrs)
      assert push_message == PushNotifications.get_push_message!(push_message.id)
    end

    test "delete_push_message/1 deletes the push_message" do
      push_message = push_message_fixture()
      assert {:ok, %PushMessage{}} = PushNotifications.delete_push_message(push_message)
      assert_raise Ecto.NoResultsError, fn -> PushNotifications.get_push_message!(push_message.id) end
    end

    test "change_push_message/1 returns a push_message changeset" do
      push_message = push_message_fixture()
      assert %Ecto.Changeset{} = PushNotifications.change_push_message(push_message)
    end
  end
end
