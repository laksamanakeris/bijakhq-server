defmodule Bijakhq.Game.Server do

  use GenServer
  require Logger

  alias Bijakhq.Quizzes
  alias Bijakhq.Game.Players
  alias Bijakhq.Game.Questions

  @name :game_server

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
      is_hidden: game_details.is_hidden,
      prize_text: "RM #{game_details.prize}"
    }

    # activate game
    Quizzes.activate_game_session(game_id)
    GenServer.cast(@name, game_state)
  end

  def set_current_question(question_number) do
    GenServer.call(@name, {:set_current_question, question_number})
  end

  def question_result(question_number) do

  end

  def game_process_result() do
    GenServer.call(@name, :game_process_result)
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

  def process_user_answer(user, question_id, answer_id) do
    GenServer.cast(@name, {:process_user_answer, user, question_id, answer_id})
  end

  def game_save_scores() do
    GenServer.cast(@name, :game_save_scores)
  end

  # Server
  def init(game_state) do
    Logger.warn "Game server initialized"
    IO.inspect game_state
    {:ok, game_state}
  end

  def handle_cast({:process_user_answer, user, question_id, answer_id}, game_state) do
    # check if user is player list
    # get game state
    # increment answer based on user selection
    # if user's answer is correct - move player to next list
    with Players.user_find(user) do
      new_state = Questions.increment_question_answer(game_state, question_id, answer_id)
      question = get_question_by_id(new_state, question_id)
      selected_answer = Enum.find(question.answers, fn u -> u.id == answer_id end)
      if selected_answer.answer == true do
        Players.user_go_to_next_question(user)
      end
      game_state = new_state
      {:noreply, game_state}
    end
  end

  def handle_cast(:game_save_scores, game_state) do
    # IO.inspect game_state
    session_id = Map.get(game_state, :session_id)
    is_hidden = Map.get(game_state, :is_hidden)
    
    if is_hidden == false do
        Players.game_save_scores(session_id)
    end

    {:noreply, game_state}
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

  def handle_call({:set_current_question, question_number}, _from, game_state) do
    # new_quest_now = case quest_now do
    #   nil ->
    #     quest_now = quest_now ++ [user]
    #   users ->
    #     Map.put(quest_now, :quest_now, Enum.uniq([user | users]))
    # end
    game_state = Map.put(game_state, :game_started, true)
    game_state = Map.put(game_state, :current_question, question_number)
    {:reply, game_state, game_state}
  end

  def handle_call(:game_process_result, _from, game_state) do

    # get prize amount
    # get game_id
    # get list of users
    # amount = prize / total users
    # IO.inspect game_state
    prize = Map.get(game_state, :prize)
    users = Players.users_next_round();
    total_users = Enum.count(users)

    result =
      if total_users > 0 do
        amount = (prize / total_users)
        amount = :erlang.float_to_binary(amount, [decimals: 2])
        Enum.map(users, fn(x) ->
            x = Map.delete(x, :__meta__)
            x = Map.delete(x, :__struct__)
            Map.put(x, :amounts, amount)
          end)
      else
        []
      end
    players = Players.set_game_result(result)
    # IO.inspect result
    {:reply, players, game_state}
  end

  defp get_question_by_id(game_state, question_id) do
    # IO.inspect game_state
    questions = game_state.questions
    question = Enum.at(questions,question_id)
    question.answers_sequence
  end

end
