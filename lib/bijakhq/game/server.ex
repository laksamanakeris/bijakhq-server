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

  # def set_current_question(question_number) do
  #   GenServer.call(@name, {:set_current_question, question_number})
  # end

  def question_result(question_number) do

  end

  # def game_process_result() do
  #   GenServer.call(@name, :game_process_result)
  # end

  # def game_end() do
  #   Quizzes.stop_game_session()
  # end

  def get_game_state do
    GenServer.call(@name, :game_state)
  end

  def update_game_state(new_game_state) do
    GenServer.call(@name, {:update_game_state, new_game_state})
  end

  def process_user_answer(user, question_id, answer_id) do
    GenServer.cast(@name, {:process_user_answer, user, question_id, answer_id})
  end

  # def game_save_scores() do
  #   GenServer.cast(@name, :game_save_scores)
  # end

  def process_question_result(question_id) do
    GenServer.call(@name, {:process_question_result, question_id})
  end

  # Server
  def init(game_state) do
    Logger.warn "Game server initialized"
    #IO.inspect game_state
    {:ok, game_state}
  end

  def handle_cast({:process_user_answer, user, question_id, answer_id}, game_state) do
    # check if user is player list
    # get game state
    # increment answer based on user selection
    # if user's answer is correct - move player to next list
    player = Players.user_find(user)
    
    if player != nil do
      Logger.warn "============================== Processing user answer #{player.id} ::  #{player.username}"
      new_state = Questions.increment_question_answer(game_state, question_id, answer_id)

      Task.start(Bijakhq.Game.Players, :process_answer, [new_state, question_id, answer_id, player])

      # question = get_question_by_id(new_state, question_id)
      # selected_answer = Enum.find(question.answers, fn u -> u.id == answer_id end)
      # if selected_answer.answer == true do
      #   Logger.warn "============================== User answer correct"
      #   Players.user_go_to_next_question(player)
      # else
      #   Logger.warn "============================== User answer wrong"
      #   if player.extra_lives_remaining > 0 do
      #     Logger.warn "============================== use extra live"
      #     player = Map.merge(player, %{extra_lives_remaining: 0,saved_by_extra_life: true})
      #     # IO.inspect player
      #     Players.user_go_to_next_question(player)
          
      #     Task.start(Bijakhq.Game.Player, :player_minus_life, [player])
      #   else
      #     Logger.warn "============================== no extra live"
      #     Map.merge(player, %{extra_lives_remaining: 0,eliminated: true})
      #   end
      # end

      game_state = new_state
      {:noreply, game_state}
    
    else
      Logger.warn "============================== User not in the player list #{user.id} ::  #{user.username}"
      # nothing happening here. so get back to normal state
      {:noreply, game_state}
    end
    
  end

  def handle_cast(:game_save_scores, game_state) do
    # #IO.inspect game_state
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
    # #IO.inspect _from
    # #IO.inspect game_state
    {:reply, game_state, game_state}
  end
  
  def handle_call({:process_question_result, question_id}, _from, game_state) do
    
    question_answers_count = Players.process_players_answers(game_state, question_id)
    # update answers count
    
    {:reply, game_state, game_state}
  end

  def handle_call({:update_game_state, new_game_state}, _from, game_state) do
    # #IO.inspect _from
    # #IO.inspect game_state
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
    # #IO.inspect game_state
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
    # #IO.inspect result
    {:reply, players, game_state}
  end

  defp get_question_by_id(game_state, question_id) do
    # #IO.inspect game_state
    questions = game_state.questions
    question = Enum.at(questions,question_id)
    question.answers_sequence
  end


  # refactoring
  
  # create new players table
  def reset_table do
    response = :ets.delete(@ets_name)
    
    :ets.new(@ets_name, [:ordered_set, :public, :named_table, read_concurrency: true, write_concurrency: true])
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
