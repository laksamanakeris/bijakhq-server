defmodule BijakhqWeb.UserSocket do
  use Phoenix.Socket

  require Logger
  alias Bijakhq.Accounts

  @max_age 365 * 24 * 60 * 60

  ## Channels
  channel "game_session:*", BijakhqWeb.GameSessionChannel
  channel "load_test:lobby", BijakhqWeb.LoadTestChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false, timeout: 120_000

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
            socket = assign(socket, :user, user)
            Logger.warn "User socket connected :: #{user.id} - #{user.username}"
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
