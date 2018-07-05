defmodule BijakhqWeb.GameSessionChannel do
  use BijakhqWeb, :channel

  alias BijakhqWeb.Presence
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.{QuizQuestion}

  alias Bijakhq.Game.Server
  alias Bijakhq.Game.Chat

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

    res = Server.game_start game_id
    with response = Server.get_game_state do
      IO.inspect response
      broadcast socket, "game:start", payload
      {:noreply, socket}
    end
  end

  def handle_in("question:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      question = Map.put(question, :question_id, question_id)
      IO.inspect question

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

  def handle_in("question:result:show", payload, socket) do
    %{"question_id" => question_id} = payload

    with game = Server.get_game_state do
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      question = Map.put(question, :question_id, question_id)
      IO.inspect question.soalan

      soalan = question.soalan
      answers = question.soalan.answers

      [answer1, answer2, answer3] = answers
      answer1 = Map.put(answer1, :total_answered, Enum.random(1..200) )
      answer2 = Map.put(answer2, :total_answered, Enum.random(1..200))
      answer3 = Map.put(answer3, :total_answered, Enum.random(1..200))

      answers = [answer1, answer2, answer3]
      soalan = Map.put(soalan, :answers, answers)
      question = Map.put(question, :soalan, soalan)

      IO.inspect question

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
    broadcast socket, "game:end", payload
    {:noreply, socket}
  end

  # Users

  def handle_in("user:answer", payload, socket) do
    %{"game_id" => game_id, "question_id" => question_id, "answer_id" => answer_id} = payload

    with game = Server.get_game_state do
      # IO.inspect game
      questions = game.questions
      question = Enum.at( questions , question_id)
      question = Map.put(question, :question_id, question_id)
      IO.inspect question.soalan

      # user_answer = Enum.at( question.soalan.answers, answer_id-1 )
      # # IO.inspect user_answer
      # case user_answer.answer do
      #   true ->
      # end

      {:reply, {:ok, payload}, socket}
    end
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
    IO.inspect socket

    {:ok, _} = Presence.track(socket, "user:#{user.id}", %{
      online_at: :os.system_time(:milli_seconds),
      user_id: user.id,
      username: user.username
    })

    {:noreply, socket}
  end

end
