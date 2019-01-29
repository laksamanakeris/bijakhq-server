defmodule Bijakhq.Game.GameManager do
  
  use GenServer
  require Logger

  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Players

  # Client
  def start_link() do
    # GenServer.start_link(__MODULE__, @chat_state, name: @name)
    Singleton.start_child(__MODULE__, [], {Bijakhq.Game.GameManager, 1})
  end

  # CALL
  # Server.game_start(game_id)
  # Server.lookup(:game_started)
  # Server.get_game_details
  # Server.set_current_question(question_id)
  # Server.get_question(question_id)
  # Server.get_question_results(question_id)
  # Server.game_process_result()
  # Players.get_game_result()
  
  # Players.lookup(user.id)
  
  # CAST
  # Server.game_save_scores()
  # Server.game_end()
  # Task.start(Bijakhq.Game.Players, :player_add_to_list, [user])
  # Players.player_answered(user, question_id, answer_id)

  # CALL
  def server_game_start(game_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_game_start, game_id})
  end
  
  def server_lookup(value) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_lookup, value})
  end
  
  def server_get_game_details do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_get_game_details})
  end
  
  def server_set_current_question(question_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_set_current_question, question_id})
  end

  def server_get_question(question_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_get_question, question_id})
  end

  def server_get_question_results(question_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_get_question_results, question_id})
  end

  def server_game_process_result() do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:server_game_process_result})
  end

  def players_get_game_result() do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:players_get_game_result})
  end

  def players_get_game_total_winners() do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:players_get_game_total_winners})
  end

  def players_get_player_game_result(user) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:players_get_player_game_result, user})
  end

  def players_lookup(param) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:players_lookup, param})
  end

  def players_check_last_question(question_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.call(pid, {:players_check_last_question, question_id})
  end


  # CAST

  # Server.game_save_scores()
  def server_game_save_scores() do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.cast(pid, {:server_game_save_scores})
  end
  
  # Server.game_end()
  def server_game_end() do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.cast(pid, {:server_game_end})
  end

  # Task.start(Bijakhq.Game.Players, :player_add_to_list, [user])
  def players_player_add_to_list(user) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.cast(pid, {:players_player_add_to_list, user})
  end

  # Players.player_answered(user, question_id, answer_id)
  def players_player_answered(user, question_id, answer_id) do
    pid = :global.whereis_name({Bijakhq.Game.GameManager, 1})
    GenServer.cast(pid, {:players_player_answered, user, question_id, answer_id})
  end


  # ========================================================
  # Server and callbacks
  # ========================================================

  def init(state) do
    Logger.warn "============================== Game Manager initialized"
    {:ok, state}
  end

  def handle_call({:server_game_start, game_id}, _from, state) do
    response = Server.game_start(game_id)
    {:reply, response, state}
  end

  def handle_call({:server_lookup, value}, _from, state) do
    response = Server.lookup(value)
    {:reply, response, state}
  end

  def handle_call({:server_get_game_details}, _from, state) do
    response = Server.get_game_details()
    {:reply, response, state}
  end

  def handle_call({:server_set_current_question, question_id}, _from, state) do
    response = Server.set_current_question(question_id)
    {:reply, response, state}
  end

  def handle_call({:server_get_question, question_id}, _from, state) do
    response = Server.get_question(question_id)
    {:reply, response, state}
  end

  def handle_call({:server_get_question_results, question_id}, _from, state) do
    response = Server.get_question_results(question_id)
    {:reply, response, state}
  end

  def handle_call({:server_game_process_result}, _from, state) do
    response = Server.game_process_result()
    {:reply, response, state}
  end

  def handle_call({:players_get_game_result}, _from, state) do
    response = Players.get_game_result()
    {:reply, response, state}
  end

  def handle_call({:players_get_game_total_winners}, _from, state) do
    response = Players.get_game_total_winners()
    {:reply, response, state}
  end

  def handle_call({:players_get_player_game_result, user}, _from, state) do
    response = Players.get_player_game_result(user)
    {:reply, response, state}
  end

  def handle_call({:players_lookup, param}, _from, state) do
    response = Players.lookup(param)
    {:reply, response, state}
  end

  def handle_call({:players_check_last_question, question_id}, _from, state) do
    response = Players.check_last_question(question_id)
    {:reply, response, state}
  end


  #  CAST
  def handle_cast({:server_game_save_scores}, state) do
    Server.game_save_scores()
    {:noreply, state}
  end

  def handle_cast({:server_game_end}, state) do
    Server.game_end()
    {:noreply, state}
  end

  def handle_cast({:players_player_add_to_list, user}, state) do
    Players.player_add_to_list(user)
    {:noreply, state}
  end

  def handle_cast({:players_player_answered, user, question_id, answer_id}, state) do
    Players.player_answered(user, question_id, answer_id)
    {:noreply, state}
  end
end