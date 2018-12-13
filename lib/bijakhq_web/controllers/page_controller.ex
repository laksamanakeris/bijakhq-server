defmodule BijakhqWeb.PageController do
  use BijakhqWeb, :controller

  def index(conn, _params) do
    conn = put_layout conn, false
    render conn, "index.html"
  end

  def gen_token(conn, _params) do
    # for i <- 100..5000, i > 100 do
    #   token = Phauxth.Token.sign(conn, i)
    #   IO.puts "#{token},"
    # end
    tokens = Enum.map(210..5000, fn x -> Phauxth.Token.sign(conn, x) end)
    
    conn = put_layout conn, false
    render(conn, "tokens.html", tokens: tokens)
  end
end
