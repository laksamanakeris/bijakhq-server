defmodule BijakhqWeb.Plug.RequireAdmin do
  @moduledoc false

  import Plug.Conn
  import Phoenix.Controller

  alias BijakhqWeb.Api.Authorize

  def init(opts), do: opts

  def call(conn, _opts) do
    user = conn.assigns[:current_user]

    if user && user.role == "admin" do
      conn
    else
      conn
      |> Authorize.error(:unauthorized, 403)
    end
  end
end
