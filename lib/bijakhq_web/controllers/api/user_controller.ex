defmodule BijakhqWeb.Api.UserController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Phauxth.Log
  alias Bijakhq.Accounts

  action_fallback BijakhqWeb.Api.FallbackController

  # the following plugs are defined in the controllers/authorize.ex file
  # plug :user_check when action in [:index, :show]
  plug :role_check, [roles: ["user", "admin"]] when action in [:index, :delete]
  plug :id_check when action in [:update, :delete]

  def index(conn, _) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    key = Phauxth.Token.sign(conn, %{"email" => email})

    with {:ok, user} <- Accounts.create_user(user_params) do
      Log.info(%Log{user: user.id, message: "user created"})

      Accounts.Message.confirm_request(email, key)
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"id" => id}) do
    user = (id == to_string(user.id) and user) || Accounts.get(id)
    render(conn, "show.json", user: user)
  end

  def update(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    {:ok, _user} = Accounts.delete_user(user)

    send_resp(conn, :no_content, "")
  end
end
