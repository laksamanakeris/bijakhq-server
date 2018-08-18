defmodule BijakhqWeb.Api.ReferralController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize

  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.User
  alias Bijakhq.Accounts.Referral

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete]
  plug :user_check when action in [:add_referral]

  def index(conn, _params) do
    referrals = Accounts.list_referrals()
    render(conn, "index.json", referrals: referrals)
  end

  def create(conn, %{"referral" => referral_params}) do
    with {:ok, %Referral{} = referral} <- Accounts.create_referral(referral_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_referral_path(conn, :show, referral))
      |> render("show.json", referral: referral)
    end
  end

  def show(conn, %{"id" => id}) do
    referral = Accounts.get_referral!(id)
    render(conn, "show.json", referral: referral)
  end

  def update(conn, %{"id" => id, "referral" => referral_params}) do
    referral = Accounts.get_referral!(id)

    with {:ok, %Referral{} = referral} <- Accounts.update_referral(referral, referral_params) do
      render(conn, "show.json", referral: referral)
    end
  end

  def delete(conn, %{"id" => id}) do
    referral = Accounts.get_referral!(id)
    with {:ok, %Referral{}} <- Accounts.delete_referral(referral) do
      send_resp(conn, :no_content, "")
    end
  end

  def add_referral(%Plug.Conn{assigns: %{current_user: user}} = conn, %{"username" => username} = _params) do
    cond do
      user.referred == true ->
        put_status(conn, :forbidden) |> render(BijakhqWeb.Api.ReferralView, "error.json", error: "User already have referral")
      user.username == username ->
        put_status(conn, :forbidden) |> render(BijakhqWeb.Api.ReferralView, "error.json", error: "Cannot refer your own self")
      true ->
        case referrer = Accounts.get_user_by_username(username) do
          nil ->
            put_status(conn, :not_found) |> render(BijakhqWeb.Api.ReferralView, "error.json", error: "User not exist")
          _ ->
            # +1 to referrer life
            # add user to referral history table
            # update user table
            {:ok, user} = Accounts.update_user(user, %{referred: true, referring_user_id: referrer.id})
            {:ok, referrer} = Accounts.update_user(referrer, %{lives: referrer.lives + 1})

            {:ok, referral} = Accounts.create_referral(%{user_id: user.id, referred_by: referrer.id})

            with referral = Accounts.get_referral!(referral.id) do
              IO.inspect referral
              render(conn, "show.json", referral: referral)
            end
        end
    end

    # if user.referred == true do
    #   put_status(conn, :forbidden) |> render(BijakhqWeb.Api.ReferralView, "error.json", error: "User already have referral")
    # else
    #   case referrer = Accounts.get_user_by_username(username) do
    #     nil ->
    #       put_status(conn, :not_found) |> render(BijakhqWeb.Api.ReferralView, "error.json", error: " already have referral")
    #     referrer ->
    #       # +1 to referrer life
    #       # add user to referral history table
    #       # update user table
    #   end
    # end
  end
end
