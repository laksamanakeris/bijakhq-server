defmodule BijakhqWeb.ConfirmView do
  use BijakhqWeb, :view

  def render("info.json", %{info: message}) do
    %{info: %{detail: message}}
  end
end
