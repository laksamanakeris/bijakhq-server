defmodule Bijakhq.Sms do
  @moduledoc """
  The Sms context.
  """

  import Ecto
  import Ecto.{Query, Changeset}, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Sms.NexmoRequest

  @doc """
  Returns the list of nexmo_requests.

  ## Examples

      iex> list_nexmo_requests()
      [%NexmoRequest{}, ...]

  """
  def list_nexmo_requests do
    Repo.all(NexmoRequest)
  end

  @doc """
  Gets a single nexmo_request.

  Raises `Ecto.NoResultsError` if the Phone verification does not exist.

  ## Examples

      iex> get_nexmo_request!(123)
      %NexmoRequest{}

      iex> get_nexmo_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nexmo_request!(id), do: Repo.get!(NexmoRequest, id)

  @doc """
  Creates a nexmo_request.

  ## Examples

      iex> create_nexmo_request(%{field: value})
      {:ok, %NexmoRequest{}}

      iex> create_nexmo_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nexmo_request(attrs \\ %{}) do
    %NexmoRequest{}
    |> NexmoRequest.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a nexmo_request.

  ## Examples

      iex> update_nexmo_request(nexmo_request, %{field: new_value})
      {:ok, %NexmoRequest{}}

      iex> update_nexmo_request(nexmo_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nexmo_request(%NexmoRequest{} = nexmo_request, attrs) do
    nexmo_request
    |> NexmoRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a NexmoRequest.

  ## Examples

      iex> delete_nexmo_request(nexmo_request)
      {:ok, %NexmoRequest{}}

      iex> delete_nexmo_request(nexmo_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nexmo_request(%NexmoRequest{} = nexmo_request) do
    Repo.delete(nexmo_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nexmo_request changes.

  ## Examples

      iex> change_nexmo_request(nexmo_request)
      %Ecto.Changeset{source: %NexmoRequest{}}

  """
  def change_nexmo_request(%NexmoRequest{} = nexmo_request) do
    NexmoRequest.changeset(nexmo_request, %{})
  end

  def get_nexmo_request_by!(attrs) do
    Repo.get_by(NexmoRequest, attrs)
  end

  def get_verified_request_id(request_id) do
    target_records =
      from(r in NexmoRequest, where: r.request_id == ^request_id and not is_nil(r.verified_at))
      |> Repo.one()
  end

  def verify_request(%NexmoRequest{} = nexmo_request) do
    change(nexmo_request, %{verified_at: DateTime.utc_now}) |> Repo.update
  end

  def complete_request(%NexmoRequest{} = nexmo_request) do
    change(nexmo_request, %{verified_at: DateTime.utc_now}) |> Repo.update
  end
end
