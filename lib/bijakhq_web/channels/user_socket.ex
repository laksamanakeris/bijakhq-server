defmodule BijakhqWeb.UserSocket do
  use Phoenix.Socket, log: false

  require Logger
  alias Bijakhq.Accounts

  @max_age 365 * 24 * 60 * 60

  @semaphore_name :semaphore_socketconn
  @semaphore_max 1000

  ## Channels
  channel "game_session:*", BijakhqWeb.GameSessionChannel
  channel "load_test:lobby", BijakhqWeb.LoadTestChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false, timeout: :infinity, transport_log: false

  def connect(%{"token" => token}, socket) do
    #IO.puts "=============================================================================================================="
    #IO.puts "Connection attempt  > #{token}"
    #IO.puts "=============================================================================================================="
    if Semaphore.acquire(@semaphore_name, @semaphore_max) do
      case Phauxth.Token.verify(socket, token, @max_age) do
        {:ok, user_id} ->
          socket = assign(socket, :user, %{id: user_id})
          # Logger.warn "SOCKET connected :: id:#{user_id} - time:#{DateTime.utc_now}"
          Logger.warn "event::socket:connect:ok | user:#{user_id} | time:#{DateTime.utc_now}"
          Semaphore.release(@semaphore_name)
          {:ok, socket}
        {:error, something} ->
          #IO.inspect something
          Logger.warn "SOCKET connect :: error - token #{something} - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
          Logger.warn "event::socket:connect:error time:#{DateTime.utc_now} details:#{something}"
          Semaphore.release(@semaphore_name)
          :error
      end
    else
      Logger.warn "SOCKET connect :: error - too many caller - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
      :error
    end
  end

  # Use this to connect
  def connect(_params, socket) do
    if Semaphore.acquire(@semaphore_name, @semaphore_max) do
      Semaphore.release(@semaphore_name)
      {:ok, socket}
    else
      Logger.warn "SOCKET connect :: too many caller - time:#{DateTime.utc_now} - #{Semaphore.count(@semaphore_name)}"
      Semaphore.release(@semaphore_name)
      :error
    end
  end

  def id(_socket), do: nil
end
