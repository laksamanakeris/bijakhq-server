defmodule BijakhqWeb.Api.UserView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      profile_picture: user.profile_picture
    }
  end

  def render("show_me.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      username: user.username,
      profile_picture: user.profile_picture
    }
  end
end
