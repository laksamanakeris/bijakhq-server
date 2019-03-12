defmodule BijakhqWeb.Api.PushMessageController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.PushNotifications
  alias Bijakhq.PushNotifications.PushMessage

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete]

  def index(conn, _params) do
    push_messages = PushNotifications.list_push_messages()
    render(conn, "index.json", push_messages: push_messages)
  end

  def create(%Plug.Conn{assigns: %{current_user: admin}} = conn, %{"notification" => push_message_params}) do
    push_message_params = Map.put(push_message_params, "author_id", admin.id)
    with {:ok, %PushMessage{} = push_message} <- PushNotifications.create_push_message(push_message_params) do
      push_message = PushNotifications.get_push_message!(push_message.id)
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_push_message_path(conn, :show, push_message))
      |> render("show.json", push_message: push_message)
    end
  end

  def show(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)
    render(conn, "show.json", push_message: push_message)
  end

  def update(%Plug.Conn{assigns: %{current_user: admin}} = conn, %{"id" => id, "notification" => push_message_params}) do
    push_message = PushNotifications.get_push_message!(id)
    # Map.put(push_message_params, :author_id, admin.id)
    with {:ok, %PushMessage{} = push_message} <- PushNotifications.update_push_message(push_message, push_message_params) do
      render(conn, "show.json", push_message: push_message)
    end
  end

  def delete(conn, %{"id" => id}) do
    push_message = PushNotifications.get_push_message!(id)
    with {:ok, %PushMessage{}} <- PushNotifications.delete_push_message(push_message) do
      send_resp(conn, :no_content, "")
    end
  end
end
