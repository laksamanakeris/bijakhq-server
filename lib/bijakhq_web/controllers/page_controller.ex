defmodule BijakhqWeb.PageController do
  use BijakhqWeb, :controller

  alias Bijakhq.Accounts

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
end
