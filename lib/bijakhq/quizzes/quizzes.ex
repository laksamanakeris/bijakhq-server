defmodule Bijakhq.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Quizzes.QuizCategory

  @doc """
  Returns the list of quiz_categories.

  ## Examples

      iex> list_quiz_categories()
      [%QuizCategory{}, ...]

  """
  def list_quiz_categories do
    Repo.all(QuizCategory)
  end

  @doc """
  Gets a single quiz_category.

  Raises `Ecto.NoResultsError` if the Quiz category does not exist.

  ## Examples

      iex> get_quiz_category!(123)
      %QuizCategory{}

      iex> get_quiz_category!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz_category!(id), do: Repo.get!(QuizCategory, id)

  @doc """
  Creates a quiz_category.

  ## Examples

      iex> create_quiz_category(%{field: value})
      {:ok, %QuizCategory{}}

      iex> create_quiz_category(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz_category(attrs \\ %{}) do
    %QuizCategory{}
    |> QuizCategory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz_category.

  ## Examples

      iex> update_quiz_category(quiz_category, %{field: new_value})
      {:ok, %QuizCategory{}}

      iex> update_quiz_category(quiz_category, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz_category(%QuizCategory{} = quiz_category, attrs) do
    quiz_category
    |> QuizCategory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizCategory.

  ## Examples

      iex> delete_quiz_category(quiz_category)
      {:ok, %QuizCategory{}}

      iex> delete_quiz_category(quiz_category)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz_category(%QuizCategory{} = quiz_category) do
    Repo.delete(quiz_category)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz_category changes.

  ## Examples

      iex> change_quiz_category(quiz_category)
      %Ecto.Changeset{source: %QuizCategory{}}

  """
  def change_quiz_category(%QuizCategory{} = quiz_category) do
    QuizCategory.changeset(quiz_category, %{})
  end
end
