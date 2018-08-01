defmodule BijakhqWeb.GameSessionChannel do
  use BijakhqWeb, :channel

  require Logger

  alias BijakhqWeb.Presence
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.{QuizQuestion}

  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Chat
  alias Bijakhq.Game.Players

  def join("game_session:lobby", payload, socket) do
    if authorized?(payload) do

      send(self(), :after_join)

      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_session:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # GAME SESSION
  def handle_in("game:start", payload, socket) do
    %{"game_id" => game_id} = payload

    # start chat timer
    Chat.timer_start()

    res = Server.game_start game_id
    with response = Server.get_game_state do
      IO.inspect response
      broadcast socket, "game:start", payload
      response = Phoenix.View.render_one(response, BijakhqWeb.Api.QuizSessionView, "game_start_details.json")
      # {:noreply, socket}
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do

      Server.set_current_question(question_id)
      Players.users_ready_next_question()
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      # complete the payload
      question = Map.put(question, :question_id, question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan.json")
      broadcast socket, "question:show", response
      {:noreply, socket}
    end
  end

  def handle_in("question:end", payload, socket) do
    %{"question_id" => question_id} = payload
    IO.inspect payload
    broadcast socket, "question:end", payload
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("question:result:get", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:result:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      # question = Map.put(question, :question_id, question_id)

      # IO.inspect question
      # IO.puts "========================================================================"

      # # soalan = Bijakhq.MapHelpers.atomize_keys(question.answers_sequence)
      # soalan = question.answers_sequence
      # # IO.inspect soalan
      # answers = soalan.answers

      # [answer1, answer2, answer3] = answers
      # answer1 = Map.put(answer1, :total_answered, Enum.random(1..200) )
      # answer2 = Map.put(answer2, :total_answered, Enum.random(1..200))
      # answer3 = Map.put(answer3, :total_answered, Enum.random(1..200))

      # answers = [answer1, answer2, answer3]
      # soalan = Map.put(soalan, :answers, answers)
      # # update the sequence again
      # question = Map.put(question, :answers_sequence, soalan)

      # IO.inspect question

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      broadcast socket, "question:result:show", response
      {:noreply, socket}
    end
  end

  def handle_in("question:result:end", payload, socket) do
    broadcast socket, "question:result:end", payload
    {:noreply, socket}
  end

  def handle_in("game:result:show", payload, socket) do
    broadcast socket, "game:result:show", payload
    {:noreply, socket}
  end

  def handle_in("game:result:end", payload, socket) do
    broadcast socket, "game:result:end", payload
    {:noreply, socket}
  end

  # GAME SESSION
  def handle_in("game:end", payload, socket) do

    Server.game_end()
    # stop chat timer
    Chat.timer_end()

    broadcast socket, "game:end", payload
    {:noreply, socket}
  end

  # Users

  def handle_in("user:answer", payload, socket) do

    user = socket.assigns.user
    process_user_answer(user, payload)

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("user:chat", payload, socket) do
    user = socket.assigns.user
    user = Phoenix.View.render_one(user, BijakhqWeb.Api.UserView, "user.json")
    message = Map.put(payload, :user, user)
    # broadcast socket, "user:chat", response
    Chat.add_message(message)
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_time", msg, socket) do
    push socket, "new_time", msg
    {:noreply, socket}
  end

  def handle_in("start_timer", _, socket) do
    BijakhqWeb.Endpoint.broadcast("timer:start", "start_timer", %{})
    {:noreply, socket}
  end

  # From user



  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  def handle_info(:after_join, socket) do
    push socket, "presence_state", Presence.list(socket)
    Chat.viewer_add()

    user = socket.assigns.user
    add_user_to_game_player_list(user)
    # IO.inspect socket

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      online_at: :os.system_time(:milli_seconds),
      user_id: user.id,
      username: user.username
    })

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    Logger.warn "Player::leave"
    # IO.inspect user_id
    # IO.inspect room_id
    IO.puts "========================"
    Chat.viewer_remove()
    {:ok, socket}
  end

  def add_user_to_game_player_list(user) do
    game_state = Server.get_game_state
    game_started = Map.get(game_state, :game_started)
    case game_started do
      false ->
        Players.user_joined(user)
    end
  end

  def process_user_answer(user, answer_payload) do

    %{"game_id" => game_id, "question_id" => question_id, "answer_id" => answer_id} = answer_payload

    # check if user is player list
    # get game state
    # increment answer based on user selection
    # if user's answer is correct - move player to next list

    with Players.user_find(user) do
      increment_question_answer(question_id, answer_id)
      question = get_question_by_id(question_id)
      selected_answer = Enum.find(question.answers, fn u -> u.id == answer_id end)
      if selected_answer.answer == true do
        Players.user_go_to_next_question(user)
      end
    end

  end

  def get_question_by_id(question_id) do
    with game = Server.get_game_state do
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      question.answers_sequence
    end
  end

  def increment_question_answer(question_id, answer_id) do
    with game = Server.get_game_state do
      # IO.inspect game
      # IO.puts "=============================================================================="
      questions = game.questions
      question = Enum.at( questions , question_id)
      question = Map.put(question, :question_id, question_id)

      old_value = question.answers_sequence.answers

      # IO.inspect old_value
      # IO.puts "=============================================================================="
      new_value = Enum.map(old_value, fn(subj) ->
        %{id: id} = subj
        if id == answer_id do
          %{subj | total_answered: subj.total_answered + 1}
        else
          subj
        end
      end)

      # IO.inspect new_value
      # IO.puts "=============================================================================="

      # update question
      answers_sequence = %{question.answers_sequence | answers: new_value}
      question = %{question | answers_sequence: answers_sequence}

      # update questions list
      old_question_list = questions

      new_question_list = Enum.map(old_question_list, fn(subj) ->
        %{id: id} = subj
        if id == question.id do
          question
        else
          subj
        end
      end)

      game = %{game | questions: new_question_list}
      Server.update_game_state(game)
    end
  end

end
