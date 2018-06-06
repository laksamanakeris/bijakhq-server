defmodule BijakhqWeb.GameSessionChannel do
  use BijakhqWeb, :channel

  alias BijakhqWeb.Presence
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.{QuizQuestion}

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
    broadcast socket, "game:start", payload
    {:noreply, socket}
  end

  def handle_in("question:show", payload, socket) do
    %{"question_id" => question_id} = payload

    quiz_question = Quizzes.get_quiz_question!(question_id)
    response = Phoenix.View.render_one(quiz_question, BijakhqWeb.Api.QuizQuestionView, "show.json")
    broadcast socket, "question:show", response
    {:noreply, socket}
  end

  def handle_in("question:end", payload, socket) do
    broadcast socket, "question:end", payload
    {:noreply, socket}
  end

  def handle_in("question:result:show", payload, socket) do
    broadcast socket, "question:result:show", payload
    {:noreply, socket}
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
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("user:chat", payload, socket) do
    user = socket.assigns.user
    user = Phoenix.View.render_one(user, BijakhqWeb.Api.UserView, "user.json")
    response = Map.put(payload, :user, user)
    broadcast socket, "user:chat", response
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
