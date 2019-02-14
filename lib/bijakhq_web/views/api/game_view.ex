defmodule BijakhqWeb.Api.GameView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.GameView

  # Game result
  def render("game_result_index.json", %{game: user}) do
    %{data: render_many(user, GameView,"game_result_user.json")}
  end

  def render("game_result_user.json", %{game: user}) do
    %{
      user_id: user.id,
      username: user.username,
      profile_picture: GameView.check_profile_picture(user.profile_picture),
      amounts: user.amounts
    }
  end

  def render("user.json", %{game: user}) do
    %{id: user.id,
      email: user.email,
      username: user.username,
      eliminated: user.eliminated,
      is_playing: user.is_playing,
      # is_tester: user.is_tester,
      # role: user.role,
      profile_picture: GameView.check_profile_picture(user.profile_picture)
    }
  end

  def check_profile_picture(nil) do
    "https://storage.googleapis.com/bijakhq_avatars/uploads/user/avatars/avatar_circle_blue_512dp.png"
  end

  def check_profile_picture(file) do
    "https://storage.googleapis.com/bijakhq_avatars/uploads/user/avatars/#{file.file_name}"
  end

end
