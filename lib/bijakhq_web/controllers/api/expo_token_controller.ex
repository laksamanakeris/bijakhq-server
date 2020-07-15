defmodule BijakhqWeb.Api.ExpoTokenController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.ExpoToken

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete]
  plug :user_check when action in [:request_payment]

  def index(conn, _params) do
    expo_tokens = PushNotifications.list_expo_tokens()
    render(conn, "index.json", expo_tokens: expo_tokens)
  end

  def create(conn, %{"data" => expo_token_params}) do
    with {:ok, %ExpoToken{} = expo_token} <- PushNotifications.create_expo_token(expo_token_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_expo_token_path(conn, :show, expo_token))
      |> render("show.json", expo_token: expo_token)
    end
  end

  def show(conn, %{"id" => id}) do
    expo_token = PushNotifications.get_expo_token!(id)
    render(conn, "show.json", expo_token: expo_token)
  end

  def update(conn, %{"id" => id, "data" => expo_token_params}) do
    expo_token = PushNotifications.get_expo_token!(id)

    with {:ok, %ExpoToken{} = expo_token} <- PushNotifications.update_expo_token(expo_token, expo_token_params) do
      render(conn, "show.json", expo_token: expo_token)
    end
  end

  def delete(conn, %{"id" => id}) do
    expo_token = PushNotifications.get_expo_token!(id)
    with {:ok, %ExpoToken{}} <- PushNotifications.delete_expo_token(expo_token) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_token(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"data" => %{ "token" => token, "platform" => platform} = expo_token_params}) do
    with {:ok, token} <- PushNotifications.create_expo_token(user, expo_token_params) do
      render(conn, "show.json", expo_token: token)
    end
  end
end
