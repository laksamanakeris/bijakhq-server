defmodule BijakhqWeb.Api.UserView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.UserView
  alias BijakhqWeb.Api.QuizSessionView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json"),
      page_number: users.page_number, 
      page_size: users.page_size,
      total_pages: users.total_pages,
      total_entries: users.total_entries
      }
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "show_user.json")}
  end

  def render("user.json", %{user: user}) do

    %{id: user.id,
        lives: user.lives, 
        username: user.username,
        phone: user.phone,
        is_tester: user.is_tester,
        role: user.role,
        profile_picture: UserView.check_profile_picture(user.profile_picture)
    }

  end
  
  def render("show_user.json", %{user: user}) do
    %{id: user.id,
        lives: user.lives, 
        username: user.username,
        phone: user.phone,
        is_tester: user.is_tester,
        role: user.role,
        profile_picture: UserView.check_profile_picture(user.profile_picture),
        balance: user.balance,
        referred: user.referred,
        referrer: render_one(user.referrer, UserView, "user.json"),
        referred_users: render_many(user.referred_users, UserView, "user.json"),
        leaderboard: render_one(user.leaderboard, UserView, "leaderboard.json"),
        total_paid: user.total_paid,
        total_games_played: user.total_games_played,
        total_game_won: user.total_game_won,
        total_game_lost: user.total_game_lost,
        games: render_many(user.games, QuizSessionView, "quiz_session.json")
        
      }

    
  end


  def render("show_me.json", %{user: user}) do
    %{
      id: user.id,
      # email: user.email,
      username: user.username,
      phone: user.phone,
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
