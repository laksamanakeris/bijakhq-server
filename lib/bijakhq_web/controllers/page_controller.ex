defmodule BijakhqWeb.PageController do
  use BijakhqWeb, :controller

  alias Bijakhq.Accounts
  alias Bijakhq.Game.GameManager

  def index(conn, _params) do
    conn = put_layout conn, false
    render conn, "index.html"
  end

  def gen_token(conn, %{"id_start" => id_start, "id_end" => id_end} = params) do
    # for i <- 100..5000, i > 100 do
    #   token = Phauxth.Token.sign(conn, i)
    #   IO.puts "#{token},"
    # end
    # users = Accounts.list_users
    # tokens = Enum.map(users, fn x -> Phauxth.Token.sign(conn, x.id) end)
    {num_start, ""} = Integer.parse(id_start)
    {num_end, ""} = Integer.parse(id_end)
    
    tokens = Enum.map(num_start..num_end, fn x -> Phauxth.Token.sign(conn, x) end)
    
    conn = put_layout conn, false
    render(conn, "tokens.html", tokens: tokens)
  end

  def gen_token_users(conn, _params) do

    users = Accounts.list_users
    tokens = Enum.map(users, fn x -> Phauxth.Token.sign(conn, x.id) end)
    
    conn = put_layout conn, false
    render(conn, "tokens.html", tokens: tokens)
  end

  def health(conn, _params) do
    {_, timestamp} = Timex.format(DateTime.utc_now, "%FT%T%:z", :strftime)
    {:ok, hostname} = :inet.gethostname
    
    json(conn, %{
      ok: timestamp,
      hostname: to_string(hostname),
      node: Node.self(),
      connected_to: Node.list()
      }) 
  end

  def extract_cache_winners(conn, _params) do
    game_details = GameManager.server_get_game_details()
    winners = GameManager.players_get_game_winner_list()
    json(conn, %{
      game: game_details,
      winners: winners
    })
  end

  def extract_cache_players(conn, _params) do
    players = GameManager.players_get_game_player_list()
    json(conn, players)
  end

end
