defmodule BijakhqWeb.Api.UserController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Phauxth.Log
  alias Bijakhq.Accounts
  alias Bijakhq.Sms
  alias Bijakhq.Sms.NexmoRequest

  action_fallback BijakhqWeb.Api.FallbackController

  # the following plugs are defined in the controllers/authorize.ex file
  # plug :user_check when action in [:index, :show]
  plug :role_check, [roles: ["admin"]] when action in [:index, :delete]
  plug :id_or_role, [roles: ["admin"]] when action in [:show]
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

  #  Custom registration using verified Nexmo request_id
  #   {
  #     "country": "MY",
  #     "language": "en",
  #     "referringUsername": "laksamanakeris",
  #     "username": "nifazu",
  #     "verificationId": "b693b2d7-0721-4186-be6a-dfe09cff0677"
  # }
  def create_user(conn, %{"country" => country,"language" => language, "username" => username, "request_id" => request_id} = user_params) do
    IO.inspect user_params
    nexmo_request = Sms.get_verified_request_id(request_id)
    IO.inspect nexmo_request
    case nexmo_request do
      nil ->
        error(conn, :unauthorized, 401)
      _ ->
        params = %{phone: nexmo_request.phone, language: language, country: country, verification_id: request_id, username: username}
        with {:ok, user} <- Accounts.create_new_user(params) do
          IO.inspect user
          BijakhqWeb.Api.VerificationController.logged_in_user(conn, user, nexmo_request)
        end
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

  def show_me(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    # user = id == to_string(user.id) and user || Accounts.get(id)
    # profile = Accounts.get(user.id);
    # render(conn, "show_me.json", %{user: user, profile: profile})
    render(conn, "show_me.json", %{user: user})
  end
end