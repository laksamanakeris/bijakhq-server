defmodule BijakhqWeb.Api.SessionView do
  use BijakhqWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end

  def render("info.json", %{info: token, role: role}) do
    %{access_token: token, role: role}
  end
end
