defmodule Bijakhq.Game.Players do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Players
  alias Bijakhq.Game.Player
  alias Bijakhq.Game.Questions
  alias Bijakhq.Accounts

  @name :game_players
  @ets_name :game_players

  @players_state %{
    quest_now: [],
    quest_next: [],
    results: []
  }

  def start_link() do
    reset_table()
    GenServer.start_link(__MODULE__, @players_state, name: @name)
  end

  def init(args) do
    Logger.warn "============================== Game Players initialized"
    #IO.inspect args
    # timer_start()
    {:ok, args}
  end

  # refactoring
  
  # create new players table
  def reset_table do
    info = :ets.info(@ets_name)
    case info do
      :undefined -> :ets.new(@ets_name, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])
      _ ->
        :ets.delete(@ets_name)
        :ets.new(@ets_name, [:set, :public, :named_table, read_concurrency: true, write_concurrency: true])
    end
  end

  # user join - add to list
  def player_add_to_list(user) do
    # check if user not exist in the list
    case Players.lookup(user.id) do
      {:ok, player} ->
        Logger.warn "============================== #{player.username} already in the player list"
      nil ->
        # get game state
        # game_started = true -> viewer
        # game_started = false -> viewer

        # now get user from database
        session_id = Server.lookup(:session_id)
        game_started = Server.lookup(:game_started)
        userdb = Accounts.get(user.id)

        case userdb do
          nil -> 
            is_hidden = Server.lookup(:is_hidden)
            case is_hidden do
              false -> :error
              true -> 
                Logger.warn "============================== Player_add_to_list #{user.id} add dummy player"
                dummyuser = Accounts.get(1)
                dummyuser = Map.put(dummyuser, :id, user.id)
                dummyuser = Map.put(dummyuser, :username, Faker.Internet.user_name)

                is_dummy = true
                add_player(dummyuser, session_id, game_started, is_dummy)
            end
          _ -> 
            case userdb.role do
              "admin" ->
                is_playing = false;
                eliminated = true;
                player = Player.new(userdb, is_playing, eliminated)
                :ets.insert(@ets_name, {player.id, player})
                # Save user to for analytics
                Task.start(Bijakhq.Quizzes, :insert_or_update_game_user, [%{game_id: session_id, user_id: userdb.id, is_viewer: true, is_player: false}])
                Logger.warn "============================== Player_add_to_list #{userdb.username} is admin. Not adding to the list"
              _ ->
                add_player(userdb, session_id, game_started)
            end
        end
        
    end
  end

  def add_player(user, session_id, game_started, is_dummy \\ false) do
    
    if game_started == false do
      is_playing = true;
      eliminated = false;
      player = Player.new(user, is_playing, eliminated)
      :ets.insert(@ets_name, {player.id, player})
      # Save user to for analytics
      if is_dummy == false do
        Task.start(Bijakhq.Quizzes, :insert_or_update_game_user, [%{game_id: session_id, user_id: user.id, is_viewer: true, is_player: true}])  
      end
    else
      is_playing = false;
      eliminated = true;
      player = Player.new(user, is_playing, eliminated)
      :ets.insert(@ets_name, {player.id, player})
      # Save user to for analytics
      if is_dummy == false do
        Task.start(Bijakhq.Quizzes, :insert_or_update_game_user, [%{game_id: session_id, user_id: user.id, is_viewer: true}])
      end
    end
  end
  
  # user answered
  def player_answered(user, question_id, answer_id) do
    case Players.lookup(user.id) do
      nil -> Logger.warn "============================== Player_answered #{user.id} not exist in the player list"
      {:ok, player} -> 
        # Logger.warn "============================== Player_answered #{player.username}"
        player = Player.update_answer(player, question_id, answer_id)
        :ets.insert(@ets_name, {player.id, player})
    end
  end

  # process users answers
  def process_players_answers(question_id) do    
    # current_question = Questions.get_question_by_id(game_state, question_id);
    # is_test_game = game_state.is_hidden
    current_question = Server.lookup("question:#{question_id}")
    if current_question == nil do
      nil
    else
      list = :ets.tab2list(@ets_name)
      answers_sequence = current_question.answers_sequence
      is_test_game = Server.lookup(:is_hidden)
      is_last_question = check_last_question(question_id)

      answers_count = 
        list
        |> Enum.reduce(%{1 => 0, 2 => 0, 3 => 0}, fn obj, map ->
          {_id, player} = obj
          case player.eliminated do
            true -> map
            false ->
              user_answer = Player.get_answer(player, question_id)
              Task.start(Bijakhq.Game.Player, :process_answer, [player, user_answer, answers_sequence, is_test_game, is_last_question])
              Map.update(map, user_answer, 1, & &1 + 1)
          end
        end)

      question_with_answers_count = update_answer_count(current_question, answers_count)
      Server.update_question(question_id, question_with_answers_count)
      
      question_with_answers_count
    end
  end

  def update_answer_count(question, answers_count) do

    %{1 => count1, 2 => count2, 3 => count3} = answers_count

    answers_sequence = question.answers_sequence
    answers = answers_sequence.answers

    #  pattern matching everything..
    [
      %{answer: answer1, id: 1, text: text1, total_answered: _},
      %{answer: answer2, id: 2, text: text2, total_answered: _},
      %{answer: answer3, id: 3, text: text3, total_answered: _}
    ] = answers

    answers = [
      %{answer: answer1, id: 1, text: text1, total_answered: count1},
      %{answer: answer2, id: 2, text: text2, total_answered: count2},
      %{answer: answer3, id: 3, text: text3, total_answered: count3}
    ]

    #  put back to the question
    answers_sequence = %{answers_sequence | answers: answers}
    question = %{question | answers_sequence: answers_sequence}

    question

  end

  def check_last_question(question_id) do
    total_question = Server.lookup(:total_questions)
    last_question_id = total_question - 1;
    if question_id == last_question_id do
      true
    else
      false
    end
  end

  # process game result
  def process_game_result do
    list = :ets.tab2list(@ets_name)
    # get winner list
    winners = get_last_standing_players() |> update_winner_list()
  end

  def get_last_standing_players do
    list = :ets.tab2list(@ets_name)
    players =
      list
      |> Enum.reduce([], fn obj, list ->
        {_id, player} = obj
        if player.eliminated == false do
          Logger.warn "============================== get_last_standing_players #{player.username} :: #{player.eliminated}"
          list = list ++ [player]
        else
          list
        end
      end)
  end

  def update_winner_list(players) do
    # get prize amounts
    # divide prizes amount with total winners
    # update winner list -> is_winner, amounts,

    prize_amount = Server.lookup(:prize)
    total_players = Enum.count(players)
    result =
      if total_players > 0 do
        amount = (prize_amount / total_players)
        amount = :erlang.float_to_binary(amount, [decimals: 2])
        list =
          Enum.map(players, fn(player) ->
            player = Map.merge(player, %{amounts: amount,is_winner: true})
            :ets.insert(@ets_name, {player.id, player})
            player
          end)
      else
        []
      end
  end

  def get_game_result do
    list = :ets.tab2list(@ets_name)
    players =
      list
      |> Enum.reduce([], fn obj, list ->
        {_id, player} = obj
        if player.is_winner == true do
          list = list ++ [player]
        else
          list
        end
      end)
  end

  def game_save_scores(game_id) do
    Logger.warn "============================== Game_save_scores :: #{game_id}"
    results = get_game_result()
    Enum.map(results, fn(subj) ->
      score = %{amount: subj.amounts, user_id: subj.id, game_id: game_id, completed_at: DateTime.utc_now}
      #  save to database
      Task.start(Bijakhq.Quizzes, :create_quiz_score, [score])
    end)
  end


  defp extra_life(lives) do
    cond do
      lives > 0 -> 1
      true -> 0
    end
  end

  def lookup(user_id) do
    case :ets.lookup(@ets_name, user_id) do
      [{^user_id, user}] -> {:ok, user}
      [] -> nil
      _ -> nil
    end
  end

end
