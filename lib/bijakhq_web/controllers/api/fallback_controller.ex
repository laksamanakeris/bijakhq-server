defmodule BijakhqWeb.Api.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use BijakhqWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(BijakhqWeb.Api.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(BijakhqWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized, message}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(BijakhqWeb.ErrorView)
    |> render(:"403", message)
  end
end
