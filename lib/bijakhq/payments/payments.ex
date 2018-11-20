defmodule Bijakhq.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Payments.Payment
  alias Bijakhq.Accounts
  # alias Bijakhq.Accounts.User
  # alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Quizzes
  alias Bijakhq.Payments

  @minimum_payment 25

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%Payment{}, ...]

  """
  def list_payments do
    Repo.all(Payment) |> Repo.preload([:user, :update_by, :status, :type])
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the Payment does not exist.

  ## Examples

      iex> get_payment!(123)
      %Payment{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id) do
    Repo.get(Payment, id) |> Repo.preload([:user, :update_by, :status, :type])
  end

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %Payment{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs \\ %{}) do
    %Payment{}
    |> Payment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %Payment{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%Payment{} = payment, attrs) do
    payment
    |> Payment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Payment.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %Payment{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%Payment{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{source: %Payment{}}

  """
  def change_payment(%Payment{} = payment) do
    Payment.changeset(payment, %{})
  end

  # get amount from score
  def get_total_payment_to_user_id(user_id) do
    amount = Repo.one(from p in Payment, where: p.user_id == ^user_id, select: sum(p.amount))
    case amount do
      nil -> 0
      _ -> amount
    end
  end

  def get_balance_by_user_id(user_id) do
    total_amount = Quizzes.get_total_amount_by_user_id(user_id)
    total_payment = get_total_payment_to_user_id(user_id)
    total_amount - total_payment
  end

  alias Bijakhq.Payments.PaymentStatus

  @doc """
  Returns the list of payment_statuses.

  ## Examples

      iex> list_payment_statuses()
      [%PaymentStatus{}, ...]

  """
  def list_payment_statuses do
    Repo.all(PaymentStatus)
  end

  @doc """
  Gets a single payment_status.

  Raises `Ecto.NoResultsError` if the Payment status does not exist.

  ## Examples

      iex> get_payment_status!(123)
      %PaymentStatus{}

      iex> get_payment_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_status!(id), do: Repo.get!(PaymentStatus, id)

  @doc """
  Creates a payment_status.

  ## Examples

      iex> create_payment_status(%{field: value})
      {:ok, %PaymentStatus{}}

      iex> create_payment_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_status(attrs \\ %{}) do
    %PaymentStatus{}
    |> PaymentStatus.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_status.

  ## Examples

      iex> update_payment_status(payment_status, %{field: new_value})
      {:ok, %PaymentStatus{}}

      iex> update_payment_status(payment_status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_status(%PaymentStatus{} = payment_status, attrs) do
    payment_status
    |> PaymentStatus.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentStatus.

  ## Examples

      iex> delete_payment_status(payment_status)
      {:ok, %PaymentStatus{}}

      iex> delete_payment_status(payment_status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_status(%PaymentStatus{} = payment_status) do
    Repo.delete(payment_status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_status changes.

  ## Examples

      iex> change_payment_status(payment_status)
      %Ecto.Changeset{source: %PaymentStatus{}}

  """
  def change_payment_status(%PaymentStatus{} = payment_status) do
    PaymentStatus.changeset(payment_status, %{})
  end


  alias Bijakhq.Payments.PaymentType

  @doc """
  Returns the list of payment_types.

  ## Examples

      iex> list_payment_types()
      [%PaymentType{}, ...]

  """
  def list_payment_types do
    Repo.all(PaymentType)
  end

  @doc """
  Gets a single payment_type.

  Raises `Ecto.NoResultsError` if the Payment type does not exist.

  ## Examples

      iex> get_payment_type!(123)
      %PaymentType{}

      iex> get_payment_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_type!(id), do: Repo.get!(PaymentType, id)

  @doc """
  Creates a payment_type.

  ## Examples

      iex> create_payment_type(%{field: value})
      {:ok, %PaymentType{}}

      iex> create_payment_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_type(attrs \\ %{}) do
    %PaymentType{}
    |> PaymentType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_type.

  ## Examples

      iex> update_payment_type(payment_type, %{field: new_value})
      {:ok, %PaymentType{}}

      iex> update_payment_type(payment_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_type(%PaymentType{} = payment_type, attrs) do
    payment_type
    |> PaymentType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentType.

  ## Examples

      iex> delete_payment_type(payment_type)
      {:ok, %PaymentType{}}

      iex> delete_payment_type(payment_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_type(%PaymentType{} = payment_type) do
    Repo.delete(payment_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_type changes.

  ## Examples

      iex> change_payment_type(payment_type)
      %Ecto.Changeset{source: %PaymentType{}}

  """
  def change_payment_type(%PaymentType{} = payment_type) do
    PaymentType.changeset(payment_type, %{})
  end



  def request_payment(user, paypal_email) do
    balance = Payments.get_balance_by_user_id(user.id)
    if balance < 50 do
      {:error, :unauthorized, error: "Balance should be more than RM#{@minimum_payment}" }
    else
      with {:ok, user} <- Accounts.update_paypal_email(user, %{"paypal_email" => paypal_email}) do
        # Paypel ID = 1
        params = %{amount: balance, updated_by: user.id, user_id: user.id, payment_type: 1}
        with {:ok, _payment} <- Payments.create_payment(params) do
          balance = Payments.get_balance_by_user_id(user.id)
          {:ok, balance}
        end
      end
    end
  end

  alias Bijakhq.Payments.PaymentBatch

  @doc """
  Returns the list of payment_batches.

  ## Examples

      iex> list_payment_batches()
      [%PaymentBatch{}, ...]

  """
  def list_payment_batches do
    Repo.all(PaymentBatch)
  end

  @doc """
  Gets a single payment_batch.

  Raises `Ecto.NoResultsError` if the Payment batch does not exist.

  ## Examples

      iex> get_payment_batch!(123)
      %PaymentBatch{}

      iex> get_payment_batch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_batch!(id), do: Repo.get!(PaymentBatch, id)

  @doc """
  Creates a payment_batch.

  ## Examples

      iex> create_payment_batch(%{field: value})
      {:ok, %PaymentBatch{}}

      iex> create_payment_batch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_batch(attrs \\ %{}) do
    %PaymentBatch{}
    |> PaymentBatch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_batch.

  ## Examples

      iex> update_payment_batch(payment_batch, %{field: new_value})
      {:ok, %PaymentBatch{}}

      iex> update_payment_batch(payment_batch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_batch(%PaymentBatch{} = payment_batch, attrs) do
    payment_batch
    |> PaymentBatch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentBatch.

  ## Examples

      iex> delete_payment_batch(payment_batch)
      {:ok, %PaymentBatch{}}

      iex> delete_payment_batch(payment_batch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_batch(%PaymentBatch{} = payment_batch) do
    Repo.delete(payment_batch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_batch changes.

  ## Examples

      iex> change_payment_batch(payment_batch)
      %Ecto.Changeset{source: %PaymentBatch{}}

  """
  def change_payment_batch(%PaymentBatch{} = payment_batch) do
    PaymentBatch.changeset(payment_batch, %{})
  end

  alias Bijakhq.Payments.PaymentBatchItem

  @doc """
  Returns the list of payment_batch_items.

  ## Examples

      iex> list_payment_batch_items()
      [%PaymentBatchItem{}, ...]

  """
  def list_payment_batch_items do
    Repo.all(PaymentBatchItem)
  end

  @doc """
  Gets a single payment_batch_item.

  Raises `Ecto.NoResultsError` if the Payment batch item does not exist.

  ## Examples

      iex> get_payment_batch_item!(123)
      %PaymentBatchItem{}

      iex> get_payment_batch_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment_batch_item!(id), do: Repo.get!(PaymentBatchItem, id)

  @doc """
  Creates a payment_batch_item.

  ## Examples

      iex> create_payment_batch_item(%{field: value})
      {:ok, %PaymentBatchItem{}}

      iex> create_payment_batch_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment_batch_item(attrs \\ %{}) do
    %PaymentBatchItem{}
    |> PaymentBatchItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment_batch_item.

  ## Examples

      iex> update_payment_batch_item(payment_batch_item, %{field: new_value})
      {:ok, %PaymentBatchItem{}}

      iex> update_payment_batch_item(payment_batch_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment_batch_item(%PaymentBatchItem{} = payment_batch_item, attrs) do
    payment_batch_item
    |> PaymentBatchItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentBatchItem.

  ## Examples

      iex> delete_payment_batch_item(payment_batch_item)
      {:ok, %PaymentBatchItem{}}

      iex> delete_payment_batch_item(payment_batch_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment_batch_item(%PaymentBatchItem{} = payment_batch_item) do
    Repo.delete(payment_batch_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment_batch_item changes.

  ## Examples

      iex> change_payment_batch_item(payment_batch_item)
      %Ecto.Changeset{source: %PaymentBatchItem{}}

  """
  def change_payment_batch_item(%PaymentBatchItem{} = payment_batch_item) do
    PaymentBatchItem.changeset(payment_batch_item, %{})
  end
end
