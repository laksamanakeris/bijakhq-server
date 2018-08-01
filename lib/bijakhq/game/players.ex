defmodule Bijakhq.Game.Players do

  use GenServer
  require Logger

  @name :game_players
  @players_state %{
    quest_now: [],
    quest_next: []
  }

  def start_link() do
   GenServer.start_link(__MODULE__, @players_state, name: @name)
  end

  def user_joined(user) do
   GenServer.call(@name, {:user_joined, user})
  end

  def users_in_channel() do
   GenServer.call(@name, :users_in_channel)
  end

  def user_left(user_id) do
    GenServer.call(@name, {:user_left, user_id})
  end

  def user_find(user_id) do
    GenServer.call(@name, {:user_find, user_id})
  end

  def user_go_to_next_question(user) do
    GenServer.call(@name, {:user_go_to_next_question, user})
  end

  def users_ready_next_question() do
    GenServer.call(@name, :users_ready_next_question)
  end

  # GenServer implementation

  def init(args) do
    Logger.warn "Game Players initialized"
    IO.inspect args
    # timer_start()
    {:ok, args}
  end

  def handle_call({:user_joined, user}, _from, players_state) do

    %{ quest_now: quest_now, quest_next: _quest_next } = players_state

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

  def handle_call(:users_ready_next_question, _from, players_state) do
    %{ quest_now: _, quest_next: quest_next } = players_state
    new_state = %{ quest_now: quest_next, quest_next: [] }
    {:reply, new_state, new_state}
  end

  def handle_call({:user_go_to_next_question, user}, _from, players_state) do

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
    {:reply, new_state, new_state}
  end

  def handle_call(:users_in_channel, _from, players_state) do
    %{ quest_now: quest_now, quest_next: _quest_next } = players_state
    {:reply, quest_now, players_state}
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
    #   IO.inspect element
    #   # match?(user, element)
    # end)
    {:reply, player, players_state}
  end
end
