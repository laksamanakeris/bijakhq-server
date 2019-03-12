defmodule BijakhqWeb.Api.PushMessageView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PushMessageView
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{push_messages: push_messages}) do
    %{data: render_many(push_messages, PushMessageView, "push_message.json")}
  end

  def render("show.json", %{push_message: push_message}) do
    %{notification: render_one(push_message, PushMessageView, "push_message.json")}
  end

  def render("push_message.json", %{push_message: push_message}) do
    %{id: push_message.id,
      message: push_message.message,
      is_completed: push_message.is_completed,
      total_tokens: push_message.total_tokens,
      inserted_at: push_message.inserted_at,
      updated_at: push_message.updated_at,
      author: push_message.user.username,
    }
  end
end
