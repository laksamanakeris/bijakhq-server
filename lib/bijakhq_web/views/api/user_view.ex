defmodule BijakhqWeb.Api.UserView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  # Game result
  def render("game_result_index.json", %{user: user}) do
    %{data: render_many(user, UserView,"game_result_user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      profile_picture: UserView.check_profile_picture(user.profile_picture)
    }
  end

  def render("show_me.json", %{user: user}) do
    %{
      id: user.id,
      # email: user.email,
      username: user.username,
      profile_picture: UserView.check_profile_picture(user.profile_picture),
      rank_weekly: user.rank_weekly,
      rank_alltime: user.rank_alltime
    }
  end

  def render("game_result_user.json", %{user: user}) do
    %{
      user_id: user.id,
      # email: user.email,
      username: user.username,
      profile_picture: UserView.check_profile_picture(user.profile_picture),
      amounts: user.amounts
    }
  end

  def render("username_available.json", %{response: response}) do
    %{
      available: response.available,
      message: response.message
    }
  end

  def check_profile_picture(nil) do
    "https://storage.googleapis.com/bijakhq_avatars/uploads/user/avatars/avatar_circle_blue_512dp.png"
  end

  def check_profile_picture(file) do
    "https://storage.googleapis.com/bijakhq_avatars/uploads/user/avatars/#{file.file_name}"
  end

end
