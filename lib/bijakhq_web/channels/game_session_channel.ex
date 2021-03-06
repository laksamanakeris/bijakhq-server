defmodule BijakhqWeb.GameSessionChannel do
  use BijakhqWeb, :channel

  require Logger

  alias BijakhqWeb.Presence
  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.{QuizQuestion}

  alias Bijakhq.Game.Chat
  # alias Bijakhq.Game.Server
  # alias Bijakhq.Game.Players

  alias Bijakhq.Game.GameManager

  @semaphore_name :semaphore_channel
  @semaphore_max 1000

  def join("game_session:lobby", payload, socket) do
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:game_session:lobby | user:#{user.id} | time:#{DateTime.utc_now}"

    if Semaphore.acquire(@semaphore_name, @semaphore_max) do
      if authorized?(socket) do
        send(self(), :after_join)
        {:ok, socket}
      else
        Semaphore.release(@semaphore_name)
        Logger.warn "GameSessionChannel join :: unauthorized - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
        {:error, %{reason: "unauthorized"}}
      end
    else
      Logger.warn "GameSessionChannel join :: error - too many callers - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
      {:error, %{reason: "Too many callers"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:ping | user:#{user.id} | time:#{DateTime.utc_now}"
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (game_session:lobby).
  def handle_in("shout", payload, socket) do
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:shout | user:#{user.id} | time:#{DateTime.utc_now}"
    broadcast socket, "shout", payload
    {:noreply, socket, :hibernate}
  end

  # GAME SESSION
  def handle_in("game:start", payload, socket) do
    user = socket.assigns.user
    %{"game_id" => game_id} = payload
    # start chat timer
    # Stop any chat process available
    Bijakhq.Game.Chat.timer_end()
    Task.start(Bijakhq.Game.Chat, :timer_start, [])

    # res = Server.game_start(game_id)
    # with response = Server.game_start(game_id) do
    with response = GameManager.server_game_start(game_id) do
      # IO.inspect response
      broadcast socket, "game:start", payload
      response = Phoenix.View.render_one(response, BijakhqWeb.Api.QuizSessionView, "game_start_details.json")
      # {:noreply, socket}
      # Logger.warn "GameSessionChannel game:start :: time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:game:start | user:#{user.id} | time:#{DateTime.utc_now} game_id:#{game_id}"
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("game:details:admin:show", _payload, socket) do
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:handle_in:game:details:admin:show | user:#{user.id} | time:#{DateTime.utc_now}"
    # game_started = Server.lookup(:game_started)
    game_started = GameManager.server_lookup(:game_started)
    case game_started do
      nil ->
        response = %{}
        {:reply, {:ok, response}, socket}
      _ -> 
        # with response = Server.get_game_details do
        with response = GameManager.server_get_game_details do
          response = Phoenix.View.render_one(response, BijakhqWeb.Api.QuizSessionView, "game_start_details.json")
          # {:noreply, socket}
          #IO.inspect response
          broadcast socket, "game:details:admin:show", response
          Logger.warn "GameSessionChannel game:details:admin:show :: time:#{DateTime.utc_now}"
          {:reply, {:ok, response}, socket}
        end
        
    end
  end

  def handle_in("question:show", payload, socket) do
    user = socket.assigns.user
    %{"question_id" => question_id} = payload
    Logger.warn "event::GameSessionChannel:handle_in:question:show | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"

    # with question = Server.set_current_question(question_id) do
    with question = GameManager.server_set_current_question(question_id) do

      # pause chat timer
      # Chat.timer_pause()
      Task.start(Bijakhq.Game.Chat, :timer_pause, [])
      # Server.set_current_question(question_id)
      # #IO.inspect game
      # questions = game.questions
      # question = Enum.at( questions , question_id)

      # # complete the payload
      # question = Map.put(question, :question_id, question_id)
      is_last_question = GameManager.players_check_last_question(question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan.json")
      response = Map.merge(response, %{last_question: is_last_question})
      broadcast socket, "question:show", response
      # Logger.warn "GameSessionChannel question:show :: - question_id:#{question_id} - time:#{DateTime.utc_now}"
      send(socket.transport_pid, :garbage_collect)
      
      {:noreply, socket, :hibernate}
    end
  end

  def handle_in("question:admin:show", payload, socket) do
    user = socket.assigns.user
    %{"question_id" => question_id} = payload

    # with question = Server.get_question(question_id) do
    with question = GameManager.server_get_question(question_id) do
      # #IO.inspect game
      # questions = game.questions
      # question = Enum.at( questions , question_id)

      # # complete the payload
      # question = Map.put(question, :question_id, question_id)
      # question = Map.put(question, :description, question.question.description)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_details.json")
      broadcast socket, "question:admin:show", response
      # Logger.warn "GameSessionChannel question:admin:show :: - question_id:#{question_id} - time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:question:admin:show | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:end", payload, socket) do
    user = socket.assigns.user
    # %{"question_id" => question_id} = payload
    #IO.inspect payload

    # start chat timer
    # Chat.timer_start()
    Task.start(Bijakhq.Game.Chat, :timer_start, [])

    broadcast socket, "question:end", payload
    # Logger.warn "GameSessionChannel question:end :: - time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:question:end | user:#{user.id} | time:#{DateTime.utc_now}"
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("question:result:get", payload, socket) do
    user = socket.assigns.user
    %{"question_id" => question_id} = payload

    # with question = Server.get_question(question_id) do
    with question = GameManager.server_get_question(question_id) do
      # #IO.inspect game
      # questions = game.questions
      # question = Enum.at( questions , question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      # Logger.warn "GameSessionChannel question:result:get :: - question_id:#{question_id} - time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:question:result:get | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:result:admin:show", payload, socket) do
    user = socket.assigns.user
    %{"question_id" => question_id} = payload

    # with question = Server.get_question_results(question_id) do
    with question = GameManager.server_get_question_results(question_id) do
      # #IO.inspect game
      # questions = game.questions
      # question = Enum.at( questions , question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      broadcast socket, "question:result:admin:show", response
      # Logger.warn "GameSessionChannel question:result:admin:show :: - question_id:#{question_id} - time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:question:result:admin:show | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"
      {:reply, {:ok, response}, socket}
    end
  end

  def handle_in("question:result:show", payload, socket) do
    user = socket.assigns.user
    %{"question_id" => question_id} = payload

    # with question = Server.get_question(question_id) do
    with question = GameManager.server_get_question(question_id) do

      # pause chat timer
      # Chat.timer_pause()
      Task.start(Bijakhq.Game.Chat, :timer_pause, [])

      is_last_question = GameManager.players_check_last_question(question_id)

      response = Phoenix.View.render_one(question, BijakhqWeb.Api.QuizQuestionView, "soalan_jawapan.json")
      response = Map.merge(response, %{last_question: is_last_question})
      broadcast socket, "question:result:show", response
      send(socket.transport_pid, :garbage_collect)
      # Logger.warn "GameSessionChannel question:result:show :: - question_id:#{question_id} - time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:question:result:show | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"
      {:noreply, socket, :hibernate}
    end
  end

  def handle_in("question:result:end", payload, socket) do
    user = socket.assigns.user

    # start chat timer
    # Chat.timer_start()
    Task.start(Bijakhq.Game.Chat, :timer_start, [])

    broadcast socket, "question:result:end", payload
    # Logger.warn "GameSessionChannel question:result:end :: time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:question:result:end | user:#{user.id} | time:#{DateTime.utc_now}"
    {:noreply, socket, :hibernate}
  end

  def handle_in("game:result:process", _payload, socket) do
    user = socket.assigns.user
    with game_result = GameManager.server_game_process_result() do
      # IO.inspect game_result
      response = Phoenix.View.render_one(game_result, BijakhqWeb.Api.GameView, "game_result_index.json")

      total_winners = GameManager.players_get_game_total_winners()
      response = Map.merge(response, %{total_winners: total_winners})
      
      broadcast socket, "game:result:process", response
      # Logger.warn "GameSessionChannel game:result:process :: time:#{DateTime.utc_now}"
      Logger.warn "event::GameSessionChannel:handle_in:game:result:process | user:#{user.id} | time:#{DateTime.utc_now}"
      {:reply, {:ok, response}, socket}
    end
    # {:noreply, socket}
  end

  def handle_in("game:result:admin:show", _payload, socket) do
    user = socket.assigns.user

    winners = GameManager.players_get_game_result()
    response = Phoenix.View.render_one(winners, BijakhqWeb.Api.GameView, "game_result_index.json")

    total_winners = GameManager.players_get_game_total_winners()
    response = Map.merge(response, %{total_winners: total_winners})
    
    broadcast socket, "game:result:admin:show", response
    # Logger.warn "GameSessionChannel game:result:admin:show :: time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:game:result:admin:show | user:#{user.id} | time:#{DateTime.utc_now}"
    send(socket.transport_pid, :garbage_collect)

    {:reply, {:ok, response}, socket}
  end


  def handle_in("game:result:show", _payload, socket) do
    user = socket.assigns.user

    # pause chat timer
    # Chat.timer_pause()
    Task.start(Bijakhq.Game.Chat, :timer_pause, [])

    # winners = Players.get_game_result()
    winners = GameManager.players_get_game_result()
    response = Phoenix.View.render_one(winners, BijakhqWeb.Api.GameView, "game_result_index.json")

    total_winners = GameManager.players_get_game_total_winners()
    response = Map.merge(response, %{total_winners: total_winners})

    broadcast socket, "game:result:show", response
    send(socket.transport_pid, :garbage_collect)
    # Logger.warn "GameSessionChannel game:result:show :: time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:game:result:show | user:#{user.id} | time:#{DateTime.utc_now}"

    {:noreply, socket, :hibernate}
  end

  def handle_in("game:result:end", _payload, socket) do
    user = socket.assigns.user

    # restart chat timer
    # Chat.timer_start()
    Task.start(Bijakhq.Game.Chat, :timer_start, [])

    # Server.game_save_scores()
    GameManager.server_game_save_scores()

    broadcast socket, "game:result:end", %{}
    # Logger.warn "GameSessionChannel game:result:end :: time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:game:result:end | user:#{user.id} | time:#{DateTime.utc_now}"
    {:noreply, socket, :hibernate}
  end

  # GAME SESSION
  def handle_in("game:end", _payload, socket) do
    user = socket.assigns.user

    # Server.game_end()
    GameManager.server_game_end()
    # stop chat timer
    Chat.timer_end()

    broadcast socket, "game:end", %{}
    # Logger.warn "GameSessionChannel game:end :: time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:handle_in:game:end | user:#{user.id} | time:#{DateTime.utc_now}"
    {:noreply, socket, :hibernate}
  end

  # Users

  def handle_in("user:answer", payload, socket) do
    %{"question_id" => question_id, "answer_id" => answer_id} = payload
    user = socket.assigns.user
    GameManager.players_player_answered(user, question_id, answer_id)
    Logger.warn "event::GameSessionChannel:handle_in:user:answer | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id} answer_id:#{answer_id}"
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("user:chat", %{"message" => message} = payload, socket) do
    user = socket.assigns.user
    Task.start(Bijakhq.Game.Chat, :add_message, [user, payload])
    
    send(socket.transport_pid, :garbage_collect)
    Logger.warn "event::GameSessionChannel:handle_in:user:chat | user:#{user.id} | time:#{DateTime.utc_now}"
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_time", msg, socket) do
    push socket, "new_time", msg
    {:noreply, socket, :hibernate}
  end

  def handle_in("start_timer", _, socket) do
    BijakhqWeb.Endpoint.broadcast("timer:start", "start_timer", %{})
    {:noreply, socket, :hibernate}
  end

  intercept ["presence_diff", "game:result:show", "question:show", "question:result:show"]
  def handle_out("presence_diff", _, socket), do: {:noreply, socket}

  # customize payload based on user
  # add in game details and user result
  def handle_out("game:result:show", msg, socket) do

    user = socket.assigns.user
    player = GameManager.players_get_player_game_result(user)
    player = Phoenix.View.render_one(player, BijakhqWeb.Api.GameView, "game_result_user.json")
    msg = Map.merge(msg, %{user: player})
    msg = Map.merge(msg, %{ts: DateTime.utc_now})

    if player != nil do
      Logger.warn "GameSessionChannel :: game:result:show  - #{player.username}"
    end
    Logger.warn "event::GameSessionChannel:handle_out:game:result:show | user:#{user.id} | time:#{DateTime.utc_now}"
    push(socket, "game:result:show", msg)
    {:noreply, socket}
  end

  # customize payload based on user
  # add in user game progress
  def handle_out("question:show", msg, socket) do
    question_id = msg.question_id
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:handle_out:question:show time:#{DateTime.utc_now} | user:#{user.id} | question_id:#{question_id}"
    
    case GameManager.players_lookup(user.id) do
      {:ok, player} ->
        data = %{
          id: player.id,
          username: player.username,
          extra_lives_remaining: player.extra_lives_remaining, 
          eliminated: player.eliminated,
          saved_by_extra_life: player.saved_by_extra_life,
          is_playing: player.is_playing
        }
        msg = Map.merge(msg, %{user: data})
        msg = Map.merge(msg, %{ts: DateTime.utc_now})
        
        push(socket, "question:show", msg)
        {:noreply, socket}
      _ ->
        msg = Map.merge(msg, %{ts: DateTime.utc_now})
        push(socket, "question:show", msg)
        {:noreply, socket}
    end
  end

  def handle_out("question:result:show", msg, socket) do
    question_id = msg.question_id
    user = socket.assigns.user
    Logger.warn "event::GameSessionChannel:handle_out:question:result:show | user:#{user.id} | time:#{DateTime.utc_now} question_id:#{question_id}"

    case GameManager.players_lookup(user.id) do
      {:ok, player} ->
        user_answer = player.answers[question_id]
        data = %{
          id: player.id,
          username: player.username,
          extra_lives_remaining: player.extra_lives_remaining, 
          eliminated: player.eliminated,
          saved_by_extra_life: player.saved_by_extra_life,
          is_playing: player.is_playing,
          answer: user_answer
        }
        
        msg = Map.merge(msg, %{user: data})
        msg = Map.merge(msg, %{ts: DateTime.utc_now})
        push(socket, "question:result:show", msg)
        {:noreply, socket}
      _ ->
        msg = Map.merge(msg, %{ts: DateTime.utc_now})
        push(socket, "question:result:show", msg)
        {:noreply, socket}
    end
  end



  # Add authorization logic here as required.
  defp authorized?(socket) do
    # enable user with token only
    user_exist = Map.has_key?(socket.assigns, :user)
  end

  def handle_info(:after_join, socket) do
    # push(socket, "presence_state", Presence.list(socket))

    user = socket.assigns.user
    # Logger.warn "CHANNEL joined :: id:#{user.id} - time:#{DateTime.utc_now}"
    
    # moved to it's own process
    # Task.start(Bijakhq.Game.Players, :player_add_to_list, [user])
    # Task.start(BijakhqWeb.Presence, :track, [socket, "user:#{user.id}", %{user_id: user.id}])
    # Task.start(BijakhqWeb.Presence, :track, [socket, user.id, %{}])
    GameManager.players_player_add_to_list(user)
    # {:ok, _} = Presence.track(socket, :players, %{user_id: user.id})
    Task.start(BijakhqWeb.Presence, :track, [socket, :players, %{user_id: user.id}])
    # push_presence_state(socket)
    # {:ok, _} = Presence.track(socket, user.id, %{
    #   online_at: inspect(System.system_time(:second))
    # })

    # release semaphore to allow next process
    Semaphore.release(@semaphore_name)
    # Logger.warn "GameSessionChannel after_join :: release semaphore - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
    Logger.warn "event::GameSessionChannel:handle_info:after_join | user:#{user.id} | time:#{DateTime.utc_now}"

    {:noreply, socket, :hibernate}
  end

  defp push_presence_state(socket) do
    push(socket, "presence_state", Presence.list(socket))
  end

  def terminate(_reason, socket) do
    user = socket.assigns.user
    # Logger.warn "Player::leave - #{user.id} - #{user.username} - #{user.role}"
    # Logger.warn "CHANNEL leave :: id:#{user.id} - time:#{DateTime.utc_now}"
    Logger.warn "event::GameSessionChannel:terminate | user:#{user.id} | time:#{DateTime.utc_now}"
    {:noreply, socket, :hibernate}
  end

end
