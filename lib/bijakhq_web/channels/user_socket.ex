defmodule BijakhqWeb.UserSocket do
  use Phoenix.Socket

  alias Bijakhq.Accounts

  @max_age 365 * 24 * 60 * 60

  ## Channels
  channel "game_session:*", BijakhqWeb.GameSessionChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false

  def connect(%{"token" => token}, socket) do
    #IO.puts "=============================================================================================================="
    #IO.puts "Connection attempt  > #{token}"
    #IO.puts "=============================================================================================================="
    case Phauxth.Token.verify(socket, token, @max_age) do
      {:ok, user_id} ->
        user = Accounts.get(user_id)
        socket = assign(socket, :user, user)
        #IO.puts "=============================================================================================================="
        #IO.puts "User connected: ID  > #{user.id}"
        #IO.puts "=============================================================================================================="
        {:ok, socket}
      {:error, something} ->
        #IO.inspect something
        :error
    end
  end

  def id(_socket), do: nil
end
