defmodule BijakhqWeb.UserSocket do
  use Phoenix.Socket, log: false

  require Logger
  alias Bijakhq.Accounts

  @max_age 365 * 24 * 60 * 60

  ## Channels
  channel "game_session:*", BijakhqWeb.GameSessionChannel
  channel "load_test:lobby", BijakhqWeb.LoadTestChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false, timeout: 500_000, transport_log: false

  def connect(%{"token" => token}, socket) do
    #IO.puts "=============================================================================================================="
    #IO.puts "Connection attempt  > #{token}"
    #IO.puts "=============================================================================================================="
    case Phauxth.Token.verify(socket, token, @max_age) do
      {:ok, user_id} ->
        user = Accounts.get(user_id)
        case user do
          nil ->
            :error
          _ ->
            socket = assign(socket, :user, %{id: user.id, lives: user.lives, high_score: user.high_score, role: user.role, username: user.username, win_count: user.win_count, profile_picture: user.profile_picture})
            Logger.warn "SOCKET connected :: id:#{user.id} - username:#{user.username} - role:#{user.role} - time:#{DateTime.utc_now}"
            {:ok, socket}
        end
      {:error, _something} ->
        #IO.inspect something
        :error
    end
  end

  # Use this to connect
  def connect(_params, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
