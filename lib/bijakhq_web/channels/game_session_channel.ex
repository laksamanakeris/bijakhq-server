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
      #IO.inspect response
      broadcast socket, "game:start", payload
      response = Phoenix.View.render_one(response, BijakhqWeb.Api.QuizSessionView, "game_start_details.json")
      # {:noreply, socket}
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("game:details:admin:show", _payload, socket) do
    with response = Server.get_game_state do
      response = Phoenix.View.render_one(response, BijakhqWeb.Api.QuizSessionView, "game_start_details.json")
      # {:noreply, socket}
      #IO.inspect response
      broadcast socket, "game:details:admin:show", response
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do

      Server.set_current_question(question_id)
      Players.users_ready_next_question()
      # #IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      # complete the payload
      question = Map.put(question, :question_id, question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan.json")
      broadcast socket, "question:show", response
      {:noreply, socket}
    end
  end

  def handle_in("question:admin:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # #IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      # complete the payload
      question = Map.put(question, :question_id, question_id)
      question = Map.put(question, :description, question.question.description)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_details.json")
      broadcast socket, "question:admin:show", response
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:end", payload, socket) do
    # %{"question_id" => question_id} = payload
    #IO.inspect payload
    broadcast socket, "question:end", payload
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("question:result:get", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # #IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:result:admin:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # #IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      broadcast socket, "question:result:admin:show", response
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:result:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # #IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      # question = Map.put(question, :question_id, question_id)

      # #IO.inspect question
      #IO.puts "========================================================================"

      # # soalan = Bijakhq.MapHelpers.atomize_keys(question.answers_sequence)
      # soalan = question.answers_sequence
      # # #IO.inspect soalan
      # answers = soalan.answers

      # [answer1, answer2, answer3] = answers
      # answer1 = Map.put(answer1, :total_answered, Enum.random(1..200) )
      # answer2 = Map.put(answer2, :total_answered, Enum.random(1..200))
      # answer3 = Map.put(answer3, :total_answered, Enum.random(1..200))

      # answers = [answer1, answer2, answer3]
      # soalan = Map.put(soalan, :answers, answers)
      # # update the sequence again
      # question = Map.put(question, :answers_sequence, soalan)

      # #IO.inspect question

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      broadcast socket, "question:result:show", response
      {:noreply, socket}
    end
  end

  def handle_in("question:result:end", payload, socket) do
    broadcast socket, "question:result:end", payload
    {:noreply, socket}
  end

  def handle_in("game:result:process", _payload, socket) do
    # broadcast socket, "game:result:show", payload
    with game_result = Server.game_process_result() do
      # #IO.inspect game
      response = Phoenix.View.render_one(game_result.results, BijakhqWeb.Api.UserView, "game_result_index.json")
      broadcast socket, "game:result:process", response
      {:reply, {:ok, response}, socket}
    end
    # {:noreply, socket}
  end

  def handle_in("game:result:show", _payload, socket) do

    winners = Players.get_game_result()
    response = Phoenix.View.render_one(winners, BijakhqWeb.Api.UserView, "game_result_index.json")
    broadcast socket, "game:result:show", response
    {:noreply, socket}
  end

  def handle_in("game:result:admin:show", _payload, socket) do

    winners = Players.get_game_result()
    response = Phoenix.View.render_one(winners, BijakhqWeb.Api.UserView, "game_result_index.json")
    broadcast socket, "game:result:admin:show", response
    {:reply, {:ok, response}, socket}
  end

  def handle_in("game:result:end", _payload, socket) do

    Server.game_save_scores()

    broadcast socket, "game:result:end", %{}
    {:noreply, socket}
  end

  # GAME SESSION
  def handle_in("game:end", _payload, socket) do

    Server.game_end()
    # stop chat timer
    Chat.timer_end()

    broadcast socket, "game:end", %{}
    {:noreply, socket}
  end

  # Users

  def handle_in("user:answer", payload, socket) do
    %{"question_id" => question_id, "answer_id" => answer_id} = payload
    user = socket.assigns.user
    # process_user_answer(user, payload)
    Server.process_user_answer(user, question_id, answer_id)
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

    user = socket.assigns.user
    Logger.warn "CHANNEL JOINED :: id:#{user.id} - username:#{user.username} - role:#{user.role} - time:#{DateTime.utc_now}"
    # Players.user_joined(user)
    Task.start(Bijakhq.Game.Players, :user_joined, [user])
    # #IO.inspect socket

    # {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
    #   online_at: :os.system_time(:milli_seconds),
    #   user_id: user.id,
    #   username: user.username
    # })
    # moved to it's own process
    Task.start(BijakhqWeb.Presence, :track, [socket, "user:#{user.id}", %{
      online_at: :os.system_time(:milli_seconds),
      user_id: user.id,
      username: user.username
    }])

    {:noreply, socket}
  end

  def terminate(_reason, socket) do
    user = socket.assigns.user
    # Logger.warn "Player::leave - #{user.id} - #{user.username} - #{user.role}"
    Logger.warn "CHANNEL leave :: id:#{user.id} - username:#{user.username} - role:#{user.role} - time:#{DateTime.utc_now}"
    {:noreply, socket}
  end

end
