defmodule Bijakhq.PushNotifications do
  @moduledoc """
  The PushNotifications context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.ExpoToken

  @doc """
  Returns the list of expo_tokens.

  ## Examples

      iex> list_expo_tokens()
      [%ExpoToken{}, ...]

  """
  def list_expo_tokens do
    Repo.all(ExpoToken)
  end

  @doc """
  Gets a single expo_token.

  Raises `Ecto.NoResultsError` if the Expo token does not exist.

  ## Examples

      iex> get_expo_token!(123)
      %ExpoToken{}

      iex> get_expo_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_expo_token!(id), do: Repo.get!(ExpoToken, id)

  @doc """
  Creates a expo_token.

  ## Examples

      iex> create_expo_token(%{field: value})
      {:ok, %ExpoToken{}}

      iex> create_expo_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_expo_token(attrs \\ %{}) do
    %ExpoToken{}
    |> ExpoToken.changeset(attrs)
    |> Repo.insert()
  end

  def create_expo_token(user, attrs) do

    %{"token" => token, "platform" => platform} = attrs

    result = check_user_token_exist(user.id, token)
    case result do
      nil -> 
        attrs = Map.put(attrs, "user_id", user.id)
        PushNotifications.create_expo_token(attrs)
      _ ->
        {:ok, result}
    end

    
    # balance = Payments.get_balance_by_user_id(user.id)
    # if balance < @minimum_payment do
    #   {:error, :unauthorized, error: "Balance should be more than RM#{@minimum_payment}" }
    # else
    #   with {:ok, user} <- Accounts.update_paypal_email(user, %{"paypal_email" => paypal_email}) do
    #     # Paypal ID = 1
    #     params = %{amount: balance, updated_by: user.id, user_id: user.id, payment_type: 1, paypal_email: paypal_email}
    #     with {:ok, _payment} <- Payments.create_payment(params) do
    #       balance = Payments.get_balance_by_user_id(user.id)
    #       {:ok, balance}
    #     end
    #   end
    # end
  end

  def check_user_token_exist(user_id, token) do
    from(u in ExpoToken, where: u.user_id == ^user_id and u.token == ^token)
    |> Repo.one
  end

  @doc """
  Updates a expo_token.

  ## Examples

      iex> update_expo_token(expo_token, %{field: new_value})
      {:ok, %ExpoToken{}}

      iex> update_expo_token(expo_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_expo_token(%ExpoToken{} = expo_token, attrs) do
    expo_token
    |> ExpoToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ExpoToken.

  ## Examples

      iex> delete_expo_token(expo_token)
      {:ok, %ExpoToken{}}

      iex> delete_expo_token(expo_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_expo_token(%ExpoToken{} = expo_token) do
    Repo.delete(expo_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking expo_token changes.

  ## Examples

      iex> change_expo_token(expo_token)
      %Ecto.Changeset{source: %ExpoToken{}}

  """
  def change_expo_token(%ExpoToken{} = expo_token) do
    ExpoToken.changeset(expo_token, %{})
  end


  @doc """
  Add new expo token.

  ## Examples

      iex> add_expo_token(%{field: value})
      {:ok, %ExpoToken{}}

      iex> create_expo_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def add_expo_token(attrs \\ %{}) do
    %ExpoToken{}
    |> ExpoToken.changeset(attrs)
    |> Repo.insert()
  end

  

  alias Bijakhq.PushNotifications.PushMessage

  @doc """
  Returns the list of push_messages.

  ## Examples

      iex> list_push_messages()
      [%PushMessage{}, ...]

  """
  def list_push_messages do
    Repo.all(PushMessage) |> Repo.preload([:user])
  end

  @doc """
  Gets a single push_message.

  Raises `Ecto.NoResultsError` if the Push message does not exist.

  ## Examples

      iex> get_push_message!(123)
      %PushMessage{}

      iex> get_push_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_push_message!(id), do: Repo.get!(PushMessage, id) |> Repo.preload([:user])

  @doc """
  Creates a push_message.

  ## Examples

      iex> create_push_message(%{field: value})
      {:ok, %PushMessage{}}

      iex> create_push_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_push_message(attrs \\ %{}) do
    %PushMessage{}
    |> PushMessage.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a push_message.

  ## Examples

      iex> update_push_message(push_message, %{field: new_value})
      {:ok, %PushMessage{}}

      iex> update_push_message(push_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_push_message(%PushMessage{} = push_message, attrs) do
    push_message
    |> PushMessage.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PushMessage.

  ## Examples

      iex> delete_push_message(push_message)
      {:ok, %PushMessage{}}

      iex> delete_push_message(push_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_push_message(%PushMessage{} = push_message) do
    Repo.delete(push_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking push_message changes.

  ## Examples

      iex> change_push_message(push_message)
      %Ecto.Changeset{source: %PushMessage{}}

  """
  def change_push_message(%PushMessage{} = push_message) do
    PushMessage.changeset(push_message, %{})
  end
end
