defmodule Bijakhq.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Quizzes
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

  alias Bijakhq.Quizzes.QuizQuestion

  @doc """
  Returns the list of quiz_questions.

  ## Examples

      iex> list_quiz_questions()
      [%QuizQuestion{}, ...]

  """
  def list_quiz_questions do
    Repo.all(QuizQuestion)
  end

  @doc """
  Gets a single quiz_question.

  Raises `Ecto.NoResultsError` if the Quiz question does not exist.

  ## Examples

      iex> get_quiz_question!(123)
      %QuizQuestion{}

      iex> get_quiz_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz_question!(id), do: Repo.get!(QuizQuestion, id)

  @doc """
  Creates a quiz_question.

  ## Examples

      iex> create_quiz_question(%{field: value})
      {:ok, %QuizQuestion{}}

      iex> create_quiz_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz_question(attrs \\ %{}) do
    %QuizQuestion{}
    |> QuizQuestion.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz_question.

  ## Examples

      iex> update_quiz_question(quiz_question, %{field: new_value})
      {:ok, %QuizQuestion{}}

      iex> update_quiz_question(quiz_question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz_question(%QuizQuestion{} = quiz_question, attrs) do
    quiz_question
    |> QuizQuestion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizQuestion.

  ## Examples

      iex> delete_quiz_question(quiz_question)
      {:ok, %QuizQuestion{}}

      iex> delete_quiz_question(quiz_question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz_question(%QuizQuestion{} = quiz_question) do
    Repo.delete(quiz_question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz_question changes.

  ## Examples

      iex> change_quiz_question(quiz_question)
      %Ecto.Changeset{source: %QuizQuestion{}}

  """
  def change_quiz_question(%QuizQuestion{} = quiz_question) do
    QuizQuestion.changeset(quiz_question, %{})
  end

  def get_random_question do

    query = from j in QuizQuestion,
            where: j.selected == false,
            order_by: [desc: j.question, asc: fragment("RANDOM()")],
            limit: 1

    Repo.one(query)
  end

  alias Bijakhq.Quizzes.QuizSession

  @doc """
  Returns the list of quiz_sessions.

  ## Examples

      iex> list_quiz_sessions()
      [%QuizSession{}, ...]

  """
  def list_quiz_sessions do
    Repo.all(QuizSession)
  end

  @doc """
  Gets a single quiz_session.

  Raises `Ecto.NoResultsError` if the Quiz session does not exist.

  ## Examples

      iex> get_quiz_session!(123)
      %QuizSession{}

      iex> get_quiz_session!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz_session!(id), do: Repo.get!(QuizSession, id)

  @doc """
  Creates a quiz_session.

  ## Examples

      iex> create_quiz_session(%{field: value})
      {:ok, %QuizSession{}}

      iex> create_quiz_session(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz_session(attrs \\ %{}) do
    %QuizSession{}
    |> QuizSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz_session.

  ## Examples

      iex> update_quiz_session(quiz_session, %{field: new_value})
      {:ok, %QuizSession{}}

      iex> update_quiz_session(quiz_session, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz_session(%QuizSession{} = quiz_session, attrs) do
    quiz_session
    |> QuizSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizSession.

  ## Examples

      iex> delete_quiz_session(quiz_session)
      {:ok, %QuizSession{}}

      iex> delete_quiz_session(quiz_session)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz_session(%QuizSession{} = quiz_session) do
    Repo.delete(quiz_session)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz_session changes.

  ## Examples

      iex> change_quiz_session(quiz_session)
      %Ecto.Changeset{source: %QuizSession{}}

  """
  def change_quiz_session(%QuizSession{} = quiz_session) do
    QuizSession.changeset(quiz_session, %{})
  end

  alias Bijakhq.Quizzes.SessionQuestion

  @doc """
  Returns the list of quiz_session_question.

  ## Examples

      iex> list_quiz_session_question()
      [%SessionQuestion{}, ...]

  """
  def list_quiz_session_question do
    Repo.all(SessionQuestion)
  end

  @doc """
  Gets a single session_question.

  Raises `Ecto.NoResultsError` if the Session question does not exist.

  ## Examples

      iex> get_session_question!(123)
      %SessionQuestion{}

      iex> get_session_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session_question!(id), do: Repo.get!(SessionQuestion, id)

  @doc """
  Creates a session_question.

  ## Examples

      iex> create_session_question(%{field: value})
      {:ok, %SessionQuestion{}}

      iex> create_session_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session_question(attrs \\ %{}) do
    %SessionQuestion{}
    |> SessionQuestion.changeset_create(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session_question.

  ## Examples

      iex> update_session_question(session_question, %{field: new_value})
      {:ok, %SessionQuestion{}}

      iex> update_session_question(session_question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session_question(%SessionQuestion{} = session_question, attrs) do
    session_question
    |> SessionQuestion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a SessionQuestion.

  ## Examples

      iex> delete_session_question(session_question)
      {:ok, %SessionQuestion{}}

      iex> delete_session_question(session_question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session_question(%SessionQuestion{} = session_question) do
    Repo.delete(session_question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session_question changes.

  ## Examples

      iex> change_session_question(session_question)
      %Ecto.Changeset{source: %SessionQuestion{}}

  """
  def change_session_question(%SessionQuestion{} = session_question) do
    SessionQuestion.changeset(session_question, %{})
  end

  def get_game_question_by!(attrs) do
    Repo.get_by(SessionQuestion, attrs) |> Repo.preload([:session, question: :category])
  end

  def get_game_question_basic_by!(attrs) do
    Repo.get_by(SessionQuestion, attrs)
  end

  def get_questions_by_game_id(game_id) do
    query =
        from q in SessionQuestion,
        where: q.session_id == ^game_id,
        preload: [:question]

    Repo.all(query)
  end

  def game_details_by_game_id(game_id) do
    game_details = Quizzes.get_quiz_session!(game_id);
    game_questions = Quizzes.get_questions_by_game_id(game_id)
                    |> Quizzes.process_questions

    IO.inspect game_details
    IO.inspect game_questions
  end

  def randomize_answer(quiz_question) do
    question = quiz_question.question
    answers = [
        %{text: quiz_question.answer, answer: true},
        %{text: quiz_question.optionB, answer: false},
        %{text: quiz_question.optionC, answer: false}
    ]

    answers = Enum.shuffle answers

    [answer1, answer2, answer3] = answers
    answer1 = Map.put(answer1, :id, 1)
    answer1 = Map.put(answer1, :total_answered, 0)

    answer2 = Map.put(answer2, :id, 2)
    answer2 = Map.put(answer2, :total_answered, 0)

    answer3 = Map.put(answer3, :id, 3)
    answer3 = Map.put(answer3, :total_answered, 0)

    answers = [answer1, answer2, answer3]

    %{
        question: question,
        answers: answers
    }
  end

  def get_questions_for_game(game_id) do
    game_questions = Quizzes.get_questions_by_game_id(game_id)
                    |> Quizzes.process_questions
  end

  def process_questions(questions_list) do
    new_list = Enum.map(questions_list, fn(x) ->
        quest = Quizzes.randomize_answer(x.question)
        Map.put(x, :soalan, quest)
        end)
  end
end