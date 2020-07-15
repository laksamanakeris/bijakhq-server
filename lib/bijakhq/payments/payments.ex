defmodule Bijakhq.Payments do
  @moduledoc """
  The Payments context.
  """
  require Logger

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Accounts
  # alias Bijakhq.Accounts.User
  # alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Quizzes
  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentRequest
  alias Bijakhq.Payments.Paypal

  alias PayPal.Payments.Payouts

  @minimum_payment 50

  @doc """
  Returns the list of payments.

  ## Examples

      iex> list_payments()
      [%PaymentRequest{}, ...]

  """
  def list_payments do
    # Repo.all(PaymentRequest) |> Repo.preload([:user, :update_by, :status, :type])
    from(p in PaymentRequest, order_by: [desc: p.id])
    |> Repo.all() |> Repo.preload([:user, :update_by, :status, :type])
  end

  def list_payments_by_type_status(type \\ 1, status \\ 1) do
    query = 
      from p in PaymentRequest,
      where: p.payment_type == ^type,
      where: p.payment_status == ^status

    Repo.all(query) |> Repo.preload([:user, :update_by, :status, :type])
  end

  @doc """
  Gets a single payment.

  Raises `Ecto.NoResultsError` if the PaymentRequest does not exist.

  ## Examples

      iex> get_payment!(123)
      %PaymentRequest{}

      iex> get_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_payment!(id) do
    Repo.get(PaymentRequest, id) |> Repo.preload([:user, :update_by, :status, :type])
  end

  @doc """
  Creates a payment.

  ## Examples

      iex> create_payment(%{field: value})
      {:ok, %PaymentRequest{}}

      iex> create_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_payment(attrs \\ %{}) do
    %PaymentRequest{}
    |> PaymentRequest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payment.

  ## Examples

      iex> update_payment(payment, %{field: new_value})
      {:ok, %PaymentRequest{}}

      iex> update_payment(payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_payment(%PaymentRequest{} = payment, attrs) do
    payment
    |> PaymentRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PaymentRequest.

  ## Examples

      iex> delete_payment(payment)
      {:ok, %PaymentRequest{}}

      iex> delete_payment(payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_payment(%PaymentRequest{} = payment) do
    Repo.delete(payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payment changes.

  ## Examples

      iex> change_payment(payment)
      %Ecto.Changeset{source: %PaymentRequest{}}

  """
  def change_payment(%PaymentRequest{} = payment) do
    PaymentRequest.changeset(payment, %{})
  end

  # get amount from score
  def get_total_payment_to_user_id(user_id) do
    amount = Repo.one(from p in PaymentRequest, where: p.user_id == ^user_id, select: sum(p.amount))
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
    if balance < @minimum_payment do
      {:error, :unauthorized, error: "Balance should be more than RM#{@minimum_payment}" }
    else
      with {:ok, user} <- Accounts.update_paypal_email(user, %{"paypal_email" => paypal_email}) do
        # Paypal ID = 1
        params = %{amount: balance, updated_by: user.id, user_id: user.id, payment_type: 1, paypal_email: paypal_email}
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
  def get_payment_batch!(id), do: Repo.get!(PaymentBatch, id) |> Repo.preload([items: [payment: [:user, :update_by, :status, :type] ]])

  def get_payment_batch_details(batch_id) do
    Payments.get_payment_batch!(batch_id) 
    |> Repo.preload([items: [payment: [:user, :update_by, :status, :type] ]])
  end

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
    Repo.all(PaymentBatchItem) |> Repo.preload([payment: [:user, :update_by, :status, :type]])
  end

  def list_payment_batch_items_by_batch_id(batch_id) do
    query = 
      from p in PaymentBatchItem,
      where: p.batch_id == ^batch_id

    Repo.all(query) |> Repo.preload([payment: [:user, :update_by, :status, :type]])
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
  
  
  def create_batch_items(batch, requests_list) do
    # status
    # 1=pending, 2=accepted, 3=rejected
    status = 1
    batch_items = 
     Enum.map(requests_list, fn(request) ->
      ref_id = "#{batch.name}-#{request.id}"
       %{batch_id: batch.id, payment_id: request.id, inserted_at: DateTime.utc_now, updated_at: DateTime.utc_now, status: status, ref_id: ref_id}
     end)
     {count, _} = Repo.insert_all(PaymentBatchItem, batch_items)
    {:ok, count}
  end

  def update_payments_status(requests_list, status) do

    payment_requests_id = Enum.map(requests_list, &(&1.id))
    new_query = 
      from p in PaymentRequest, 
      where: p.id in ^payment_requests_id
    
    {count, _} = Repo.update_all(new_query, set: [updated_at: DateTime.utc_now, payment_status: status])
    {:ok, count}
  end

  def process_paypal(batch_details) do
    
  end


  # New batch processing flow
  # - check for new request
  # - create new batch
  # - get list new request
  # - create batch items from list
  # - update item status in list to - processing
  # - generate payload
  # - submit to API
  def create_new_batch_request do

    payment_type = 1 # paypal
    payment_status = 1 # new request
    payment_requests_new = Payments.list_payments_by_type_status(payment_type,payment_status)

    count = Enum.count(payment_requests_new)

    if count > 0 do
      # create batch name
      batch_name = PaymentBatch.generate_batch_name()
      {:ok, batch} = Payments.create_payment_batch(%{name: batch_name})

      payment_type = 1 # paypal
      payment_status = 1 # new request
      payment_requests_new = Payments.list_payments_by_type_status(payment_type,payment_status)
      {:ok, count} = Payments.create_batch_items(batch, payment_requests_new)
      
      payment_status_update = 2 #processed
      {:ok, count} = Payments.update_payments_status(payment_requests_new, payment_status_update)

      # payloads
      setup_payloads = Paypal.process_batch_id(batch.id)
      response = PayPal.Payments.Payouts.create(setup_payloads)

      case response do
        {:error, error_reason} ->
          Logger.warn "Payments :: create_new_batch_request - time:#{DateTime.utc_now} - #{error_reason}"
          {:error, error: "Error creating new batch - #{error_reason}" }
        {:ok, paypal_response} ->
          # process payload
          Paypal.process_payout_batch_response(paypal_response)
          payment_batch = Payments.get_payment_batch!(batch.id)
          {:ok, payment_batch}
      end
      
    else
      {:error, error: "No new payment request" }
    end

  end

  def update_batch_status(batch_id) do
    batch = Payments.get_payment_batch!(batch_id)
    payout_batch_id = batch.payout_batch_id
    response = PayPal.Payments.Payouts.show(payout_batch_id)

    case response do
      {:error, error_reason} ->
        Logger.warn "Payments :: update_batch_status - time:#{DateTime.utc_now} - #{error_reason}"
        {:error, error: "Error updating batch - #{error_reason}" }
      {:ok, paypal_response} ->
        # process payload
        Paypal.update_payout_batch_status(paypal_response)
        {:ok, paypal_response}
    end
  end

end
