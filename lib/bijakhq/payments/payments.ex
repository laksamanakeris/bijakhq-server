defmodule Bijakhq.Payments do
  @moduledoc """
  The Payments context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Payments.Payment
  alias Bijakhq.Accounts.User
  alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Quizzes
  alias Bijakhq.Payments

  @doc """
  Returns the list of payment_history.

  ## Examples

      iex> list_payment_history()
      [%Payment{}, ...]

  """
  def list_payment_history do
    Repo.all(Payment)
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
  def get_payment!(id), do: Repo.get!(Payment, id)

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
end
