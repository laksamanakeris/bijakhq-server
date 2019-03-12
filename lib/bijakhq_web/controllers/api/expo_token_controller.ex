defmodule BijakhqWeb.Api.ExpoTokenController do
  use BijakhqWeb, :controller

  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.ExpoToken

  action_fallback BijakhqWeb.FallbackController

  def index(conn, _params) do
    expo_tokens = PushNotifications.list_expo_tokens()
    render(conn, "index.json", expo_tokens: expo_tokens)
  end

  def create(conn, %{"expo_token" => expo_token_params}) do
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

  def update(conn, %{"id" => id, "expo_token" => expo_token_params}) do
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
end
