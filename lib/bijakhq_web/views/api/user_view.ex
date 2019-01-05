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
      is_tester: user.is_tester,
      role: user.role,
      profile_picture: UserView.check_profile_picture(user.profile_picture)
    }
  end

  def render("show_me.json", %{user: user}) do
    %{
      id: user.id,
      # email: user.email,
      username: user.username,
      paypal_email: user.paypal_email,
      profile_picture: UserView.check_profile_picture(user.profile_picture),
      balance: user.balance,
      lives: user.lives,
      referred: user.referred,
      referrer: render_one(user.referrer, UserView, "user.json"),
      leaderboard: render_one(user.leaderboard, UserView, "leaderboard.json"),
    }
  end

  def render("leaderboard.json", %{user: leaderboard} ) do
    %{alltime: alltime, weekly: weekly} = leaderboard
    %{
      alltime: %{
        ranking: alltime.rank,
        amounts: alltime.amounts
      },
      weekly: %{
        ranking: weekly.rank,
        amounts: weekly.amounts
      },
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
