defmodule Bijakhq.Game.Players do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Player

  @name :game_players
  @players_state %{
    quest_now: [],
    quest_next: [],
    results: []
  }

  def start_link() do
    :ets.new(:players, [:set, :public, :named_table])
    GenServer.start_link(__MODULE__, @players_state, name: @name)
  end

  def user_joined(user) do
    game_state = Server.get_game_state
    game_started = Map.get(game_state, :game_started)
    Logger.warn "Connected user is #{user.role}"
    if game_started == false and user.role != "admin" do
      player = %Bijakhq.Game.Player{id: user.id, lives: user.lives, high_score: user.high_score, role: user.role, username: user.username, win_count: user.win_count, profile_picture: user.profile_picture}
      #IO.inspect user
      #IO.inspect player
      :ets.insert(:players, {player.id, player})

      # Save user to for analytics
      Task.start(Bijakhq.Quizzes, :insert_or_update_game_user, [%{game_id: game_state.session_id, user_id: user.id, is_viewer: true, is_player: true}])
      
      GenServer.call(@name, {:user_joined, player})
    
    else
      Task.start(Bijakhq.Quizzes, :insert_or_update_game_user, [%{game_id: game_state.session_id, user_id: user.id, is_viewer: true}])
    end
    # When user join - limit his life to 1 extra pergame only
  end

  def users_in_channel() do
   GenServer.call(@name, :users_in_channel)
  end

  def users_next_round() do
    GenServer.call(@name, :users_next_round)
   end

  def user_left(user_id) do
    GenServer.call(@name, {:user_left, user_id})
  end

  def user_find(user_id) do
    GenServer.call(@name, {:user_find, user_id})
  end

  def user_go_to_next_question(user) do
    GenServer.cast(@name, {:user_go_to_next_question, user})
  end

  def users_ready_next_question() do
    GenServer.call(@name, :users_ready_next_question)
  end

  def set_game_result(users) do
    GenServer.call(@name, {:set_game_result, users})
  end

  def get_game_result() do
    GenServer.call(@name, :get_game_result)
  end

  def game_save_scores(game_id) do
    #IO.puts "Players::game_save_scores -> #{game_id}"
    GenServer.call(@name, {:game_save_scores, game_id})
  end

  # GenServer implementation

  def init(args) do
    Logger.warn "Game Players initialized"
    #IO.inspect args
    # timer_start()
    {:ok, args}
  end

  def handle_call({:user_joined, user}, _from, players_state) do

    # %{ quest_now: quest_now, quest_next: _quest_next } = players_state
    quest_now = Map.get(players_state, :quest_now)

    # new_quest_now = case quest_now do
    #   nil ->
    #     quest_now = quest_now ++ [user]
    #   users ->
    #     Map.put(quest_now, :quest_now, Enum.uniq([user | users]))
    # end
    quest_now = quest_now ++ [user]
    quest_now = Enum.uniq(quest_now)

    new_state = Map.put(players_state, :quest_now, quest_now)
    {:reply, new_state, new_state}
  end

  def handle_call({:user_left, user_id}, _from, players_state) do
    new_users = players_state
      |> Map.get(:quest_now)
      |> Enum.reject(&(&1.id == user_id))

    new_state = Map.update!(players_state, :quest_now, fn(_) -> new_users end)

    {:reply, new_state, new_state}
  end

  def handle_call({:user_find, user}, _from, players_state) do
    player_list = Map.get(players_state, :quest_now)

    player = Enum.find(player_list, fn u -> u.id == user.id end)

    # Enum.find(player_list, fn(element) ->
    #   #IO.inspect element
    #   # match?(user, element)
    # end)
    {:reply, player, players_state}
  end


  # Games
  def handle_call({:set_game_result, users}, _from, players_state) do
    Logger.warn "set_game_result"
    new_state = Map.put(players_state, :results, users)
    {:reply, new_state, new_state}
  end

  def handle_call(:get_game_result, _from, players_state) do
    Logger.warn "get_game_result"
    results = Map.get(players_state, :results)
    {:reply, results, players_state}
  end


  def handle_call({:game_save_scores, game_id}, _from, players_state) do
    Logger.warn "game_save_scores"
    results = Map.get(players_state, :results)

    Enum.map(results, fn(subj) ->
      score = %{amount: subj.amounts, user_id: subj.id, game_id: game_id, completed_at: DateTime.utc_now}
      with {:ok, %QuizScore{} = quiz_score} <- Bijakhq.Quizzes.create_quiz_score(score) do
        #IO.inspect quiz_score
      end

    end)

    {:reply, results, players_state}
  end

  def handle_call(:users_ready_next_question, _from, players_state) do
    %{ quest_now: _, quest_next: quest_next, results: _ } = players_state
    new_state = %{ quest_now: quest_next, quest_next: [], results: [] }
    {:reply, new_state, new_state}
  end

  def handle_call(:users_in_channel, _from, players_state) do
    %{ quest_now: quest_now, quest_next: _quest_next } = players_state
    {:reply, quest_now, players_state}
  end

  def handle_call(:users_next_round, _from, players_state) do
    %{ quest_now: _quest_now, quest_next: quest_next } = players_state
    {:reply, quest_next, players_state}
  end

  def handle_cast({:user_go_to_next_question, user}, players_state) do

    %{ quest_now: _quest_now, quest_next: quest_next } = players_state

    # new_quest_now = case quest_now do
    #   nil ->
    #     quest_now = quest_now ++ [user]
    #   users ->
    #     Map.put(quest_now, :quest_now, Enum.uniq([user | users]))
    # end
    quest_next = quest_next ++ [user]
    quest_next = Enum.uniq(quest_next)

    new_state = Map.put(players_state, :quest_next, quest_next)
    # {:reply, new_state, new_state}
    {:noreply, new_state}
  end

end
