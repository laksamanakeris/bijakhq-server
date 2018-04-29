defmodule BijakhqWeb.Api.SessionView do
  use BijakhqWeb, :view

  def render("info.json", %{info: token}) do
    %{access_token: token}
  end
end
