defmodule BijakhqWeb.Api.PushMessageView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.PushMessageView
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{push_messages: push_messages}) do
    %{data: render_many(push_messages, PushMessageView, "push_message.json"),
    page_number: push_messages.page_number, 
      page_size: push_messages.page_size,
      total_pages: push_messages.total_pages,
      total_entries: push_messages.total_entries
    }
  end

  def render("show.json", %{push_message: push_message}) do
    %{notification: render_one(push_message, PushMessageView, "push_message.json")}
  end

  def render("push_message.json", %{push_message: push_message}) do
    %{id: push_message.id,
      message: push_message.message,
      title: push_message.title,
      is_tester: push_message.is_tester,
      is_completed: push_message.is_completed,
      total_tokens: push_message.total_tokens,
      inserted_at: push_message.inserted_at,
      updated_at: push_message.updated_at,
      author: push_message.user.username,
    }
  end
end
