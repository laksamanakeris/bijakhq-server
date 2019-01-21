defmodule Bijakhq.Game.UserCounter do

  use GenServer
  require Logger

  alias BijakhqWeb.Presence
  alias Bijakhq.Game.Server
  alias Bijakhq.Game.GameManager

  # @name :game_chat
  @room_name "game_session:lobby"
  @interval_time 1_000 * 1

  # This is chat state
  @counter_state %{
    timer_ref: nil,
    current_viewing: 0
  }
  # Client
  def start_link() do
    Singleton.start_child(__MODULE__, @counter_state, {Bijakhq.Game.UserCounter, 1})
  end

  def timer_start do
    pid = :global.whereis_name({Bijakhq.Game.UserCounter, 1})
    GenServer.cast(pid, :timer_start)
  end

  def timer_pause do
    pid = :global.whereis_name({Bijakhq.Game.UserCounter, 1})
    GenServer.cast(pid, :timer_pause)
  end

  def timer_end do
    pid = :global.whereis_name({Bijakhq.Game.UserCounter, 1})
    GenServer.cast(pid, :timer_end)
  end

  # Server and callbacks
  def init(initial_data) do
    Logger.warn "============================== Game Viewers Counter initialized"
    timer_start();
    counter_state = initial_data
    {:ok, counter_state}
  end

  # Timer stuff
  def handle_cast(:timer_start, counter_state) do
    Logger.warn "Game Viewers :: Timer Start"
    timer_ref = schedule_timer @interval_time
    new_state = Map.put(counter_state, :timer_ref, timer_ref)
    {:noreply, new_state}
  end

  def handle_cast(:timer_end, counter_state) do
    Logger.warn "Game Viewers :: Timer Stop"
    %{ timer_ref: timer_ref, current_viewing: _current_viewing} = counter_state
    cancel_timer(timer_ref)
    new_state = Map.put(counter_state, :timer_ref, nil)
    # Reset timer
    {:noreply, @counter_state}
  end

  def handle_cast(:timer_pause, counter_state) do
    Logger.warn "Game Viewers :: Timer pause"
    %{ timer_ref: timer_ref, current_viewing: _current_viewing} = counter_state
    cancel_timer(timer_ref)
    new_state = Map.put(counter_state, :timer_ref, nil)
    # Reset timer
    {:noreply, new_state}
  end


  def handle_info(:update, counter_state) do
    # Logger.warn "update"

    %{ timer_ref: _timer_ref, current_viewing: current_viewing} = counter_state

    users_connected = Presence.list(@room_name) |> Map.size

    current_viewing =
      if is_integer(users_connected) do
        users_connected
      else
        current_viewing
      end
    
    broadcast(current_viewing);

    timer_ref = schedule_timer @interval_time
    new_state = %{ timer_ref: timer_ref, current_viewing: current_viewing }
    {:noreply, new_state}
  end


  # public
  def broadcast(users_count) do
    params = %{current_viewing: users_count}
    BijakhqWeb.Endpoint.broadcast("game_session:lobby", "user:count", params)
  end

  defp schedule_timer(interval), do: Process.send_after self(), :update, interval
  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)

end
