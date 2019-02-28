defmodule Bijakhq.Quizzes do
  @moduledoc """
  The Quizzes context.
  """

  import Ecto.Query, warn: false
  alias Bijakhq.Repo

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizCategory
  alias Bijakhq.Quizzes.QuizGameQuestion
  alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Accounts.User
  alias Bijakhq.Accounts

  @doc """
  Returns the list of quiz_categories.

  ## Examples

      iex> list_quiz_categories()
      [%QuizCategory{}, ...]

  """
  def list_quiz_categories do
    # Repo.all(QuizCategory)
    from(p in QuizCategory, order_by: [desc: p.id])
    |> Repo.all()
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
  def get_quiz_category!(id), do: Repo.get(QuizCategory, id)

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
    # Repo.all(QuizQuestion) |> Repo.preload([:games])
    from(p in QuizQuestion, order_by: [desc: p.id])
    |> Repo.all()
    |> Repo.preload([:games])
  end
  
  def list_quiz_questions(page) do
    query = from q in QuizQuestion,
            order_by: [desc: q.id],
            preload: [:games]
    page = Repo.paginate(query, page: page)
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
  def get_quiz_question!(id), do: Repo.get(QuizQuestion, id) |> Repo.preload([:games])

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
    from(p in QuizSession, order_by: [desc: p.id])
    |> Repo.all()
    |> Repo.preload([:game_questions])
  end

  def list_quiz_sessions(page \\ 1) do
    query = from q in QuizSession,
            order_by: [desc: q.id],
            preload: [:game_questions]
    page = Repo.paginate(query, page: page)
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
  def get_quiz_session!(id) do
    Repo.get(QuizSession, id)
    |> Repo.preload([game_questions: (from q in QuizGameQuestion, order_by: [asc: q.sequence], preload: :question )])

  end

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


  @doc """
  Returns the list of quiz_game_question.

  ## Examples

      iex> list_quiz_game_question()
      [%QuizGameQuestion{}, ...]

  """
  def list_quiz_game_question do
    Repo.all(QuizGameQuestion)
  end

  @doc """
  Gets a single game_question.

  Raises `Ecto.NoResultsError` if the Session question does not exist.

  ## Examples

      iex> get_game_question!(123)
      %QuizGameQuestion{}

      iex> get_game_question!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game_question!(id), do: Repo.get(QuizGameQuestion, id)

  @doc """
  Creates a game_question.

  ## Examples

      iex> create_game_question(%{field: value})
      {:ok, %QuizGameQuestion{}}

      iex> create_game_question(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game_question(attrs \\ %{}) do
    %QuizGameQuestion{}
    |> QuizGameQuestion.changeset_create(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game_question.

  ## Examples

      iex> update_game_question(game_question, %{field: new_value})
      {:ok, %QuizGameQuestion{}}

      iex> update_game_question(game_question, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game_question(%QuizGameQuestion{} = game_question, attrs) do
    game_question
    |> QuizGameQuestion.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizGameQuestion.

  ## Examples

      iex> delete_game_question(game_question)
      {:ok, %QuizGameQuestion{}}

      iex> delete_game_question(game_question)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game_question(%QuizGameQuestion{} = game_question) do
    Repo.delete(game_question)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game_question changes.

  ## Examples

      iex> change_game_question(game_question)
      %Ecto.Changeset{source: %QuizGameQuestion{}}

  """
  def change_game_question(%QuizGameQuestion{} = game_question) do
    QuizGameQuestion.changeset(game_question, %{})
  end

  def get_game_question_by!(attrs) do
    QuizGameQuestion |> order_by(asc: :sequence) |> Repo.get_by(attrs) |> Repo.preload([:session, question: [:category,:games]])
  end

  def get_game_question_basic_by!(attrs) do
    Repo.get_by(QuizGameQuestion, attrs)
  end

  def get_questions_by_game_id(game_id) do
    query =
        from q in QuizGameQuestion,
        where: q.session_id == ^game_id,
        preload: [:session, question: [:category,:games]],
        order_by: [asc: q.sequence]

    Repo.all(query)
  end

  def get_questions_by_game_id_basic(game_id) do
    query =
        from q in QuizGameQuestion,
        where: q.session_id == ^game_id,
        order_by: [asc: q.sequence]

    Repo.all(query)
  end

  def get_game_questions_with_empty_answers_sequence do
    query =
        from q in QuizGameQuestion,
        where: q.answers_sequence == ^%{},
        preload: [:session, question: :category],
        order_by: [asc: q.sequence]

    Repo.all(query)
  end

  def game_details_by_game_id(game_id) do
    game_details = Quizzes.get_quiz_session!(game_id);
    game_questions = Quizzes.get_questions_by_game_id(game_id)
                    |> Quizzes.process_questions

    #IO.inspect game_details
    #IO.inspect game_questions
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
    Quizzes.get_questions_by_game_id(game_id)
  end

  def process_questions(questions_list) do
    Enum.map(questions_list, fn(x) ->
        quest = Quizzes.randomize_answer(x.question)
        Map.put(x, :soalan, quest)
    end)
  end

  # Update game_question if "answers_sequence" is empty
  def update_game_questions_random_answers do
    questions = Quizzes.get_game_questions_with_empty_answers_sequence
    Enum.map(questions, fn(quest) ->
        #IO.inspect quest
        # question_randomized = Quizzes.randomize_answer(quest.question);
        # Quizzes.update_game_question(quest, %{answers_sequence: question_randomized, sequence: quest.sequence})
    end)
  end

  def get_initial_game_state(game_id) do
    game_details = Quizzes.get_quiz_session!(game_id)
    # game_details = Bijakhq.MapHelpers.atomize_keys(game_details.game_questions)

    game_questions = Enum.map(game_details.game_questions, fn(quest) ->
        atomized = Bijakhq.MapHelpers.atomize_keys(quest.answers_sequence)
        quest = Map.put(quest, :answers_sequence, atomized)
        # #IO.inspect quest
      end)

    %{
      game_details: game_details,
      game_questions: game_questions
    }
  end


  # get upcoming game
  def get_upcoming_game(show_hidden \\ false) do

    now = Timex.now
    query =
        from q in QuizSession,
        where: q.is_completed == false and q.is_active != true and q.time > ^now,
        preload: [:game_questions],
        order_by: [asc: q.time]
    
    case show_hidden do
      true ->
        # show all games
        Repo.all(query)
      false ->
        # show all games except hidden
        query = from q in query, where: q.is_hidden == false
        Repo.all(query)
    end
  end

  def get_current_game(show_hidden \\ false) do
    query =
        from q in QuizSession,
        where: q.is_active == true,
        preload: [:game_questions],
        order_by: [asc: q.time]
    
    case show_hidden do
      true ->
        # show all games
        Repo.one(query)
      false ->
        # show all games except hidden
        query = from q in query, where: q.is_hidden == false
        Repo.one(query)
    end
  end

  def activate_game_session(game_id) do
    from(p in QuizSession, where: p.is_active == true)
    |> Repo.update_all(set: [is_active: false])

    quiz_session = Quizzes.get_quiz_session!(game_id)
    case quiz_session do
      nil -> nil
      quiz_session ->
        with {:ok, %QuizSession{} = quiz_session} <- Quizzes.update_quiz_session(quiz_session, %{is_active: true}) do
          quiz_session
          :ok
        end
    end

  end

  def complete_game_session(game_id) do
    quiz_session = Quizzes.get_quiz_session!(game_id)
    case quiz_session do
      nil -> nil
      quiz_session ->
        with {:ok, %QuizSession{} = quiz_session} <- Quizzes.update_quiz_session(quiz_session, %{is_completed: true}) do
          quiz_session
          :ok
        end
    end

  end

  def stop_game_session do
    from(p in QuizSession, where: p.is_active == true)
    |> Repo.update_all(set: [is_active: false])
  end

  def get_game_now_status(show_hidden) do
    current = Quizzes.get_current_game(show_hidden)
    upcoming = Quizzes.get_upcoming_game(show_hidden)

    %{
      current: current,
      upcoming: upcoming
    }
  end







  def list_quiz_scores do
    Repo.all(QuizScore)
  end

  def get_quiz_score!(id), do: Repo.get(QuizScore, id)

  def create_quiz_score(attrs \\ %{}) do
    %QuizScore{}
    |> QuizScore.changeset(attrs)
    |> Repo.insert()
  end

  def update_quiz_score(%QuizScore{} = quiz_score, attrs) do
    quiz_score
    |> QuizScore.changeset(attrs)
    |> Repo.update()
  end

  def delete_quiz_score(%QuizScore{} = quiz_score) do
    Repo.delete(quiz_score)
  end

  def change_quiz_score(%QuizScore{} = quiz_score) do
    QuizScore.changeset(quiz_score, %{})
  end

  def score_queries do
    query = from r in QuizScore,
        join: d in User,
        where: r.user_id == d.id

    query = from [r, d] in query,
        join: game in QuizSession,
        where: r.game_id == game.id

    query
  end


  def list_quiz_scores_weekly do
    query = score_queries()

    query = from [res, dri, rac] in query,
        where: res.inserted_at >= ^Timex.beginning_of_week(Timex.now),
        where: res.inserted_at <= ^Timex.end_of_week(Timex.now),
        select: %{
          user: dri,
          user_id: dri.id,
          amounts: sum(res.amount),
          rank: fragment("rank() OVER (ORDER BY sum(q0.amount) DESC)")
          },
        group_by: dri.id,
        order_by: [desc: sum(res.amount)],
        limit: 100

    Repo.all query
  end

  def list_quiz_scores_all_time do
    query = score_queries()

    query = from [res, dri, rac] in query,
        # where: rac.round <= 3,
        select: %{
          user: dri,
          user_id: dri.id,
          amounts: sum(res.amount),
          rank: fragment("rank() OVER (ORDER BY sum(q0.amount) DESC)")
          },
        group_by: dri.id,
        order_by: [desc: sum(res.amount)],
        limit: 100

    Repo.all query
  end

  def get_user_ranking_alltime(user_id) do
    query = from r in QuizScore,
        join: d in User,
        where: r.user_id == d.id

    query = from [res, dri] in query,
        # where: dri.id == ^user_id,
        select: %{
          username: dri.username,
          user_id: dri.id,
          amounts: sum(res.amount),
          rank: 0
          },
        group_by: dri.id,
        order_by: [desc: sum(res.amount)]

    query = from res in query,
          where: res.user_id == ^user_id

    Repo.one query
  end

  def get_user_ranking_weekly(user_id) do
    query = from r in QuizScore,
        join: d in User,
        where: r.user_id == d.id

    query = from [res, dri] in query,
      where: res.inserted_at >= ^Timex.beginning_of_week(Timex.now),
      where: res.inserted_at <= ^Timex.end_of_week(Timex.now),
        select: %{
          username: dri.username,
          user_id: dri.id,
          amounts: sum(res.amount),
          rank: 0
          },
        group_by: dri.id,
        order_by: [desc: sum(res.amount)]

    query = from res in query,
          where: res.user_id == ^user_id

    Repo.one query
  end


  def get_total_amount_by_user_id(user_id) do
    amount = Repo.one(from p in QuizScore, where: p.user_id == ^user_id, select: sum(p.amount))
    case amount do
      nil -> 0
      _ -> amount
    end
  end

  def get_user_leaderboard_weekly(user_id) do
    user_data = get_user_ranking_weekly(user_id)
    case user_data do
      nil ->
        %{amounts: 0, rank: 101, user_id: user_id}
      _ ->
        list = list_quiz_scores_weekly()
        # #IO.inspect list
        dash = Enum.find(list, fn(x) -> x.user_id == user_data.user_id end)
        case dash do
          nil ->
            user_data
          _ ->
            %{amounts: amounts, rank: rank, user_id: user_id, user: user} = dash
            %{amounts: amounts, rank: rank, user_id: user_id, username: user.username}
        end
    end
  end

  def get_user_leaderboard_all_time(user_id) do
    user_data = get_user_ranking_alltime(user_id)
    case user_data do
      nil ->
        %{amounts: 0, rank: 101, user_id: user_id}
      _ ->
        list = list_quiz_scores_all_time()
        # #IO.inspect list
        dash = Enum.find(list, fn(x) -> x.user_id == user_data.user_id end)
        case dash do
          nil ->
            user_data
          _ ->
            %{amounts: amounts, rank: rank, user_id: user_id, user: user} = dash
            %{amounts: amounts, rank: rank, user_id: user_id, username: user.username}
        end
    end
  end


  alias Bijakhq.Quizzes.QuizUser

  @doc """
  Returns the list of quiz_game_users.

  ## Examples

      iex> list_quiz_game_users()
      [%QuizUser{}, ...]

  """
  def list_quiz_game_users do
    Repo.all(QuizUser)
  end

  @doc """
  Gets a single quiz_user.

  Raises `Ecto.NoResultsError` if the Quiz user does not exist.

  ## Examples

      iex> get_quiz_user!(123)
      %QuizUser{}

      iex> get_quiz_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_quiz_user!(id), do: Repo.get!(QuizUser, id)

  @doc """
  Creates a quiz_user.

  ## Examples

      iex> create_quiz_user(%{field: value})
      {:ok, %QuizUser{}}

      iex> create_quiz_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_quiz_user(attrs \\ %{}) do
    %QuizUser{}
    |> QuizUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a quiz_user.

  ## Examples

      iex> update_quiz_user(quiz_user, %{field: new_value})
      {:ok, %QuizUser{}}

      iex> update_quiz_user(quiz_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_quiz_user(%QuizUser{} = quiz_user, attrs) do
    quiz_user
    |> QuizUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a QuizUser.

  ## Examples

      iex> delete_quiz_user(quiz_user)
      {:ok, %QuizUser{}}

      iex> delete_quiz_user(quiz_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_quiz_user(%QuizUser{} = quiz_user) do
    Repo.delete(quiz_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking quiz_user changes.

  ## Examples

      iex> change_quiz_user(quiz_user)
      %Ecto.Changeset{source: %QuizUser{}}

  """
  def change_quiz_user(%QuizUser{} = quiz_user) do
    QuizUser.changeset(quiz_user, %{})
  end

  def insert_or_update_game_user(%{game_id: game_id, user_id: user_id} = quiz_user) do
    case game_id do
      nil -> nil #do nothing
      game_id ->
        case item = Repo.get_by(QuizUser, %{game_id: game_id, user_id: user_id}) do
          nil -> Quizzes.create_quiz_user(quiz_user)
          _ -> Quizzes.update_quiz_user(item, quiz_user)
        end
    end

  end

  def get_players_by_game_id(game_id) do
    
      query =
          from u in QuizUser,
          where: u.game_id == ^game_id,
          preload: [:user]
  
      Repo.all(query)
  end

  def add_extra_life_to_players_by_game(game_id) do
    
    # get user_ids from quiz_user
    #  go through each user id and get user life
    #  increment life by 1
    #  update user table
    players = get_players_by_game_id(game_id)
    
    Enum.each players, fn player ->       
      # IO.inspect player
      Task.start(Bijakhq.Accounts, :update_user, [player.user, %{lives: player.user.lives + 1}])
    end

    # just return players
    players
  end



end
