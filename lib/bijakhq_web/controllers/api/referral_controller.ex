defmodule BijakhqWeb.Api.ReferralController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize

  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.Referral

  action_fallback BijakhqWeb.Api.FallbackController

  plug :role_check, [roles: ["admin"]] when action in [:index, :create, :show, :update, :delete]
  plug :user_check when action in []

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
end
