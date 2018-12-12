defmodule Bijakhq.Game.Players do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizScore
  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Players
  alias Bijakhq.Game.Player
  alias Bijakhq.Game.Questions

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
    Logger.warn "Connected user is #{user.role} - ID: #{user.id} | #{user.username}"
    if game_started == false and user.role != "admin" do
      player = 
        %Bijakhq.Game.Player{
          id: user.id, lives: user.lives, high_score: user.high_score, role: user.role, username: user.username, win_count: user.win_count, profile_picture: user.profile_picture,
          is_playing: true,
          eliminated: false,
          extra_lives_remaining: extra_life(user.lives)
        }
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

  def get_players_state do
    GenServer.call(@name, :get_players_state)
  end

  # GenServer implementation

  def init(args) do
    Logger.warn "Game Players initialized"
    #IO.inspect args
    # timer_start()
    {:ok, args}
  end

  def handle_call(:get_players_state, _from, player_state) do
    #IO.inspect player_state
    {:reply, player_state, player_state}
  end

  def handle_call({:user_joined, user}, _from, players_state) do

    # %{ quest_now: quest_now, quest_next: _quest_next } = players_state
    quest_next = Map.get(players_state, :quest_next)

    # new_quest_now = case quest_now do
    #   nil ->
    #     quest_now = quest_now ++ [user]
    #   users ->
    #     Map.put(quest_now, :quest_now, Enum.uniq([user | users]))
    # end
    quest_next = quest_next ++ [user]
    quest_next = Enum.uniq(quest_next)

    new_state = Map.put(players_state, :quest_next, quest_next)
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

  defp extra_life(lives) do
    cond do
      lives > 0 -> 1
      true -> 0
    end
  end

  def process_answer(game_state, question_id, answer_id, player) do
    
    question = Questions.get_question_by_id(game_state, question_id)
    selected_answer = Enum.find(question.answers, fn u -> u.id == answer_id end)

    if selected_answer.answer == true do
      Logger.warn "============================== User answer correct"
      # Players.user_go_to_next_question(player)
      Task.start(Players, :user_go_to_next_question, [player])
    else
      Logger.warn "============================== User answer wrong"
      if player.extra_lives_remaining > 0 do
        Logger.warn "============================== use extra live"
        player = Map.merge(player, %{extra_lives_remaining: 0,saved_by_extra_life: true})
        # IO.inspect player
        # Players.user_go_to_next_question(player)
        
        Task.start(Players, :user_go_to_next_question, [player])
        
        if game_state.is_hidden == false do
          Task.start(Bijakhq.Game.Player, :player_minus_life, [player])
        end
      else
        Logger.warn "============================== no extra live"
        Map.merge(player, %{extra_lives_remaining: 0,eliminated: true})
      end
    end

  end

end
