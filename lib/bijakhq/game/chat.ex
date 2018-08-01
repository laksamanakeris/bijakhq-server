defmodule Bijakhq.Game.Chat do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes

  @name :game_chat
  @interval_time 1_000 * 1

  # This is chat state
  @chat_state %{
    timer_ref: nil,
    messages: [],
    current_viewing: 0
  }
  # Client
  def start_link, do: GenServer.start_link(__MODULE__, @chat_state, name: @name)


  def get_messages do
    GenServer.call(@name, {:get_messages})
  end

  def add_message(message) do
    GenServer.call(@name, {:add_message, message})
  end

  def viewer_add() do
    GenServer.cast(@name, :viewer_add)
  end

  def viewer_remove() do
    GenServer.cast(@name, :viewer_remove)
  end

  def timer_start do
    GenServer.cast(@name, :timer_start)
  end

  def timer_end do
    GenServer.cast(@name, :timer_stop)
  end

  # Server and callbacks
  def init(initial_data) do
    Logger.warn "Game chat initialized"
    chat_state = initial_data
    IO.inspect chat_state
    # timer_start()
    {:ok, chat_state}
  end

  def handle_call({:get_messages}, _from, chat_state) do
    # IO.inspect chat_state
    %{ timer_ref: _timer_ref, messages: messages, current_viewing: current_viewing} = chat_state
    {:reply, %{messages: messages, current_viewing: current_viewing}, chat_state}
  end

  def handle_call({:add_message, message}, _from, chat_state) do
    # IO.inspect message
    # IO.inspect chat_state
    %{ timer_ref: _timer_ref, messages: messages, current_viewing: _} = chat_state
    messages = messages ++ [message]
    new_state = Map.put(chat_state, :messages, messages)
    {:reply, messages, new_state}
  end

  # Viewer stuff

  def handle_cast(:viewer_add, chat_state) do
    Logger.warn "Viewer::add"
    %{ timer_ref: _timer_ref, messages: _messages, current_viewing: current_viewing} = chat_state
    current_viewing = current_viewing + 1
    new_state = Map.put(chat_state, :current_viewing, current_viewing)
    {:noreply, new_state}
  end

  def handle_cast(:viewer_remove, chat_state) do
    Logger.warn "Viewer::remove"
    %{ timer_ref: _timer_ref, messages: _messages, current_viewing: current_viewing} = chat_state
    current_viewing = current_viewing - 1
    new_state = Map.put(chat_state, :current_viewing, current_viewing)
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
    %{ timer_ref: timer_ref, messages: _messages, current_viewing: _current_viewing} = chat_state
    cancel_timer(timer_ref)
    # new_state = Map.put(chat_state, :timer_ref, nil)
    # Reset timer
    {:noreply, @chat_state}
  end


  def handle_info(:update, chat_state) do
    # Logger.warn "update"

    %{ timer_ref: _timer_ref, messages: messages, current_viewing: current_viewing} = chat_state
    broadcast(%{messages: messages, current_viewing: current_viewing})

    timer_ref = schedule_timer @interval_time
    new_state = %{ timer_ref: timer_ref, messages: [], current_viewing: current_viewing }
    {:noreply, new_state}
  end

  defp schedule_timer(interval), do: Process.send_after self(), :update, interval
  defp cancel_timer(nil), do: :ok
  defp cancel_timer(ref), do: Process.cancel_timer(ref)
  defp broadcast(messages) do
    # Logger.warn "broadcast"
    # IO.inspect messages
    BijakhqWeb.Endpoint.broadcast("game_session:lobby", "user:chat", messages)
  end

end
