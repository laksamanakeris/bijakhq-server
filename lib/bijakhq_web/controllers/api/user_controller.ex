defmodule BijakhqWeb.Api.UserController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Phauxth.Log
  alias Bijakhq.{Accounts, Repo}
  alias Bijakhq.Quizzes
  alias Bijakhq.Sms
  alias Bijakhq.Sms.NexmoRequest
  alias Bijakhq.ImageFile
  alias Bijakhq.Payments

  alias Bijakhq.Utils.WordFilter

  action_fallback BijakhqWeb.Api.FallbackController

  # the following plugs are defined in the controllers/authorize.ex file
  # plug :user_check when action in [:index, :show]
  plug :role_check, [roles: ["admin"]] when action in [:index, :update, :delete]
  plug :id_or_role, [roles: ["admin"]] when action in [:show]
  # plug :id_check when action in [:update, :delete]
  plug :user_check when action in [:upload_image_profile, :show_me, :update_me]

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
    #IO.inspect user_params
    nexmo_request = Sms.get_verified_request_id(request_id)
    #IO.inspect nexmo_request
    case nexmo_request do
      nil ->
        error(conn, :unauthorized, 401)
      _ ->
        params = %{phone: nexmo_request.phone, language: language, country: country, verification_id: request_id, username: username}
        with {:ok, user} <- Accounts.create_new_user(params) do
          #IO.inspect user
          BijakhqWeb.Api.VerificationController.logged_in_user(conn, user, nexmo_request)
        end
    end
  end

  def show(conn, %{"id" => id}) do
    user = Accounts.get(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get(id)
    with {:ok, user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get(id)
    {:ok, _user} = Accounts.delete_user(user)

    send_resp(conn, :no_content, "")
  end

  def show_me(%Plug.Conn{assigns: %{current_user: user}} = conn, _) do
    # user = id == to_string(user.id) and user || Accounts.get(id)
    # profile = Accounts.get(user.id);
    # render(conn, "show_me.json", %{user: user, profile: profile})
    user =
        add_balance_to_user(user)
        |> add_leaderboard
    render(conn, "show_me.json", %{user: user})
  end

  def update_me(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"username" => username} = user_params) do
    with {:ok, user} <- Accounts.update_username(user, user_params) do
      user =
        add_balance_to_user(user)
        |> add_leaderboard
      render(conn, "show_me.json", %{user: user})
    end
  end

  def add_balance_to_user(user)do
    user = user |> Repo.preload(:referrer)
    balance = Payments.get_balance_by_user_id(user.id)
    user |> Map.put(:balance, balance)
  end

  def add_leaderboard(user) do
    weekly = Quizzes.get_user_leaderboard_weekly(user.id)
    alltime = Quizzes.get_user_leaderboard_all_time(user.id)
    leaderboard = %{alltime: alltime, weekly: weekly}
    user |> Map.put(:leaderboard, leaderboard)
  end

  def upload_image_profile(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"profile_picture" => _params} = user_params) do
    #IO.puts "===================================================================================="
    #IO.inspect user
    #IO.inspect user_params
    #IO.puts "===================================================================================="

    # uploaded = ImageFile.store(params)
    # #IO.inspect uploaded

    with {:ok, user} <- Accounts.upload_image(user, user_params) do
      user = 
        add_balance_to_user(user)
        |> add_leaderboard
      render(conn, "show_me.json", user: user)
    end
    # render(conn, "show_me.json", user: user)
  end

  def check_username(conn, %{"username" => username} = user_params) do

    username = String.downcase(username)
    cond do
      Bijakhq.Utils.WordFilter.has_profanity?(username) == true ->
        response = %{available: false, message: "Username is not available" }
        render(conn, "username_available.json", %{response: response})
      is_alphanumeric(username) == false ->
        response = %{available: false, message: "Username is not available" }
        render(conn, "username_available.json", %{response: response})
      true ->
        check_username_from_table(conn, %{"username" => username})
    end
  end

  defp check_username_from_table(conn, user_params) do
    case result = Accounts.get_by(user_params) do
      nil ->
        # render(conn, "username_unavailable.json", nil)
        response = %{available: true, message: "Username is available" }
        render(conn, "username_available.json", %{response: response})
      _ ->
        # render(conn, "empty.json", nil)
        response = %{available: false, message: "Username is not available" }
        render(conn, "username_available.json", %{response: response})
    end
  end

  defp is_alphanumeric(username) do
    username =~ ~r/^[0-9A-Za-z]+$/
  end
end
