defmodule Bijakhq.Game.Chat do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias BijakhqWeb.Presence
  alias Bijakhq.Game.Server
  alias Bijakhq.Game.GameManager

  @name :game_chat
  @room_name "game_session:lobby"
  @interval_time 2_500 * 1

  # This is chat state
  @chat_state %{
    timer_ref: nil,
    messages: [],
    current_viewing: 0
  }
  # Client
  def start_link() do
    # GenServer.start_link(__MODULE__, @chat_state, name: @name)
    Singleton.start_child(__MODULE__, @chat_state, {Bijakhq.Game.Chat, 1})
  end


  def get_messages do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.call(pid, {:get_messages})
  end

  def add_message(user, payload) do
    case GameManager.players_lookup(user.id) do
      {:ok, player} ->
        user = Phoenix.View.render_one(player, BijakhqWeb.Api.UserView, "user.json")
        message = Map.put(payload, :user, user)
        # broadcast socket, "user:chat", response
        pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
        GenServer.cast(pid, {:add_message, message})
        :ok
      nil ->
        :error
    end
  end

  def viewer_add() do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.cast(pid, :viewer_add)
  end

  def viewer_remove() do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.cast(pid, :viewer_remove)
  end

  def viewer_update(count) do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.cast(pid, {:viewer_update, count})
  end

  def timer_start do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.cast(pid, :timer_start)
  end

  def timer_end do
    pid = :global.whereis_name({Bijakhq.Game.Chat, 1})
    GenServer.cast(pid, :timer_stop)
  end

  # Server and callbacks
  def init(initial_data) do
    Logger.warn "============================== Game Chat initialized"
    chat_state = initial_data
    #IO.inspect chat_state
    # timer_start()
    game_started = Server.lookup(:game_started)
    if game_started != nil do
      timer_start()
    end
    {:ok, chat_state}
  end

  def handle_call({:get_messages}, _from, chat_state) do
    # #IO.inspect chat_state
    %{ timer_ref: _timer_ref, current_viewing: _current_viewing, messages: messages} = chat_state
    {:reply, %{messages: messages}, chat_state}
  end

  def handle_cast({:add_message, message}, chat_state) do
    # #IO.inspect message
    # #IO.inspect chat_state
    %{ timer_ref: _timer_ref, current_viewing: _current_viewing, messages: messages} = chat_state
    messages = messages ++ [message]
    new_state = Map.put(chat_state, :messages, messages)
    {:noreply, new_state}
  end

  # Timer stuff

  def handle_cast(:timer_start, chat_state) do
    Logger.warn "Timer Start"
    timer_ref = schedule_timer @interval_time
    new_state = Map.put(chat_state, :timer_ref, timer_ref)
    {:noreply, new_state}
  end

  def handle_cast(:timer_stop, chat_state) do
    Logger.warn "Timer Stop"
    %{ timer_ref: timer_ref, current_viewing: _current_viewing, messages: _messages} = chat_state
    cancel_timer(timer_ref)
    # new_state = Map.put(chat_state, :timer_ref, nil)
    # Reset timer
    {:noreply, @chat_state}
  end


  def handle_info(:update, chat_state) do
    # Logger.warn "update"

    %{ timer_ref: _timer_ref, messages: messages, current_viewing: current_viewing} = chat_state

    users_connected = Presence.list(@room_name) |> Map.size

    current_viewing =
      if is_integer(users_connected) do
        users_connected
      else
        current_viewing
      end
    
    broadcast(%{messages: messages, current_viewing: current_viewing})
    timer_ref = schedule_timer @interval_time
    new_state = %{ timer_ref: timer_ref, current_viewing: current_viewing, messages: []}
    {:noreply, new_state}
  end

  defp schedule_timer(interval), do: Process.send_after self(), :update, interval
  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)
  defp broadcast(messages) do
    BijakhqWeb.Endpoint.broadcast("game_session:lobby", "user:chat", messages)
  end

end
