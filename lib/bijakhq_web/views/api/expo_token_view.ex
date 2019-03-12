defmodule BijakhqWeb.Api.ExpoTokenView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.ExpoTokenView

  def render("index.json", %{expo_tokens: expo_tokens}) do
    %{data: render_many(expo_tokens, ExpoTokenView, "expo_token.json")}
  end

  def render("show.json", %{expo_token: expo_token}) do
    %{data: render_one(expo_token, ExpoTokenView, "expo_token.json")}
  end

  def render("expo_token.json", %{expo_token: expo_token}) do
    %{id: expo_token.id,
      token: expo_token.token,
      platform: expo_token.platform,
      is_active: expo_token.is_active}
  end
end
