defmodule BijakhqWeb.Api.QuizUserView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizUserView

  def render("index.json", %{quiz_game_users: quiz_game_users}) do
    %{data: render_many(quiz_game_users, QuizUserView, "quiz_user.json")}
  end

  def render("show.json", %{quiz_user: quiz_user}) do
    %{data: render_one(quiz_user, QuizUserView, "quiz_user.json")}
  end

  def render("quiz_user.json", %{quiz_user: quiz_user}) do
    %{id: quiz_user.id,
      is_player: quiz_user.is_player,
      is_viewer: quiz_user.is_viewer}
  end
end
