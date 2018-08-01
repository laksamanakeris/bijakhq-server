defmodule Bijakhq.Game.Server do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes

  @name :game_server

  @initial_state %{
    game_started: false,
    session_id: nil,
    total_questions: 0,
    current_question: nil,
    questions: [],
    prize: 0,
    prize_text: "RM 0"
  }
  # Client
  def start_link, do: GenServer.start_link(__MODULE__, @initial_state, name: @name)

  def game_start(game_id) do

    # Game state format - @initial_state
    game_data = Quizzes.get_initial_game_state(game_id)
    IO.inspect game_data

    %{ game_details: game_details, game_questions: game_questions } = game_data

    game_state = %{
      game_started: false,
      session_id: game_details.id,
      total_questions: Enum.count(game_questions),
      current_question: nil,
      questions: game_questions,
      prize: game_details.prize,
      prize_text: "RM #{game_details.prize}"
    }

    # activate game
    Quizzes.activate_game_session(game_id)
    GenServer.cast(@name, game_state)
  end

  def question_show(question_number) do

  end

  def question_result(question_number) do

  end

  def game_result() do
  end

  def game_end() do
    Quizzes.stop_game_session()
  end

  def get_game_state do
    GenServer.call(@name, :game_state)
  end

  def update_game_state(new_game_state) do
    GenServer.call(@name, {:update_game_state, new_game_state})
  end

  # Server
  def init(game_state) do
    Logger.warn "Game server initialized"
    IO.inspect game_state
    {:ok, game_state}
  end

  def handle_cast(new_state, game_state) do
    game_state = new_state
    {:noreply, game_state}
  end

  def handle_call(:game_state, _from, game_state) do
    # IO.inspect _from
    # IO.inspect game_state
    {:reply, game_state, game_state}
  end

  def handle_call({:update_game_state, new_game_state}, _from, game_state) do
    # IO.inspect _from
    # IO.inspect game_state
    {:reply, new_game_state, new_game_state}
  end

end
