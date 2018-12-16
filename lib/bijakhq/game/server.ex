defmodule Bijakhq.Game.Server do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias Bijakhq.Game.Players
  alias Bijakhq.Game.Questions
  alias Bijakhq.Game.Server

  @name :game_server
  @ets_name :game_server

  @initial_state %{
    game_started: false,
    is_hidden: false,
    session_id: nil,
    total_questions: 0,
    current_question: nil,
    questions: [],
    prize: 0,
    prize_text: "RM 0"
  }
  # Client API
  def start_link() do
    :ets.new(@ets_name, [:ordered_set, :public, :named_table, read_concurrency: true, write_concurrency: true])
    GenServer.start_link(__MODULE__, @initial_state, name: @name)
  end

  # Server
  def init(game_state) do
    Logger.warn "Game server initialized"
    #IO.inspect game_state
    {:ok, game_state}
  end

  # refactoring
  
  # create new players table
  def reset_table do
    info = :ets.info(@ets_name)
    case info do
      :undefined -> :ets.new(@ets_name, [:ordered_set, :public, :named_table, read_concurrency: true, write_concurrency: true])
      _ ->
        :ets.delete(@ets_name)
        :ets.new(@ets_name, [:ordered_set, :public, :named_table, read_concurrency: true, write_concurrency: true])
      
    end
  end

  def game_start(game_id) do

    reset_table()

    # Game state format - @initial_state
    game_data = Quizzes.get_initial_game_state(game_id)
    #IO.inspect game_data

    %{ game_details: game_details, game_questions: game_questions } = game_data

    game_state = %{
      game_started: false,
      session_id: game_details.id,
      total_questions: Enum.count(game_questions),
      current_question: nil,
      questions: game_questions,
      prize: game_details.prize,
      is_hidden: game_details.is_hidden,
      prize_text: "RM #{game_details.prize}"
    }
    
    :ets.insert(@ets_name, {:game_started, false})
    :ets.insert(@ets_name, {:session_id, game_details.id})
    :ets.insert(@ets_name, {:total_questions, Enum.count(game_questions)})
    :ets.insert(@ets_name, {:current_question, nil})
    :ets.insert(@ets_name, {:prize, game_details.prize})
    :ets.insert(@ets_name, {:is_hidden, game_details.is_hidden})
    :ets.insert(@ets_name, {:prize_text, "RM #{game_details.prize}"})

    questions = game_questions
    
    questions = for {c, counter} <- Enum.with_index(questions), do: {counter, c}
    
    Enum.map(questions, fn item -> 
      {key, soalan} = item


      description =  soalan.question.description
      answers_sequence = soalan.answers_sequence
      answers_sequence = Map.put(answers_sequence, :description, description)

      question = 
        %{
          session_id: game_details.id,
          # question_id: soalan.question_id,
          question_id: key,
          total_correct: soalan.total_correct,
          sequence: soalan.sequence,
          is_completed: soalan.is_completed,
          id: soalan.id,
          answers_totals: soalan.answers_totals,
          answers_sequence: answers_sequence
        }

      :ets.insert(@ets_name, {"question:#{key}", question})
    end)

    # activate game
    Quizzes.activate_game_session(game_id)

    Server.get_game_details
  end

  def get_game_details do
    game_state = :ets.tab2list @ets_name
    # reconstruct data
    [
      {:current_question, current_question},
      {:game_started, game_started},
      {:is_hidden, is_hidden},
      {:prize, prize},
      {:prize_text,prize_text},
      {:session_id, session_id},
      {:total_questions, total_questions} | tail ] = game_state

      count = total_questions - 1

    questions = 
      Enum.map(0..count, fn num -> 
        question = lookup("question:#{num}")
      end)
    

    game_details = %{
      game_started: game_started,
      is_hidden: is_hidden,
      session_id: session_id,
      total_questions: total_questions,
      current_question: current_question,
      questions: questions,
      prize: prize,
      prize_text: prize_text
    }

  end

  def set_current_question(question_number) do
    :ets.insert(@ets_name, {:current_question, question_number})
    question = lookup("question:#{question_number}")
  end

  def update_question(question_id, question) do
    :ets.insert(@ets_name, {"question:#{question_id}", question})
  end

  def get_question(question_number) do
    question = lookup("question:#{question_number}")
  end

  def get_question_results(question_id) do
    result = Players.process_players_answers(question_id)
  end

  def game_process_result() do
    winners = Players.process_game_result();
  end

  def game_save_scores() do
    session_id = lookup(:session_id)
    is_hidden = lookup(:is_hidden)
    
    if is_hidden == false do
        Players.game_save_scores(session_id)
    end
  end

  def game_end() do
    Quizzes.stop_game_session()
    reset_table();
    Players.reset_table()
  end

  # UTILS
  def lookup(key) do
    case :ets.lookup(@ets_name, key) do
      [{^key, item}] -> item
      [] -> nil
    end
  end

end
