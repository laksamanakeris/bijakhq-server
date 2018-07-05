defmodule Bijakhq.Game.Server do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes

  @name :game_server

  @initial_state %{
    session_id: nil,
    total_questions: 0,
    current_question: 0,
    questions: [],
    prize: 0,
    prize_text: "RM 0",
    current_viewing: 0
  }
  # Client
  def start_link, do: GenServer.start_link(__MODULE__, @initial_state, name: @name)

  def game_start(game_id) do

    game_details = Quizzes.get_quiz_session!(game_id)
    game_questions = Quizzes.get_questions_for_game(game_id)

    game_state = %{
      session_id: game_details.id,
      total_questions: game_details.total_questions,
      current_question: 0,
      questions: game_questions,
      prize: game_details.prize,
      prize_text: "RM #{game_details.prize}",
      current_viewing: 0
    }

    GenServer.cast(@name, game_state)
  end

  def question_show(question_number) do

  end

  def question_result(question_number) do

  end

  def game_result() do
  end

  def game_end() do
  end

  def get_game_state do
    GenServer.call(@name, :game_state)
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
    IO.inspect _from
    IO.inspect game_state
    {:reply, game_state, game_state}
  end

end
