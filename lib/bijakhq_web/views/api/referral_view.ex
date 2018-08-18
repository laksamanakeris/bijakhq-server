defmodule BijakhqWeb.Api.ReferralView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.ReferralView
  alias BijakhqWeb.Api.UserView

  def render("index.json", %{referrals: referrals}) do
    %{data: render_many(referrals, ReferralView, "referral.json")}
  end

  def render("show.json", %{referral: referral}) do
    %{data: render_one(referral, ReferralView, "referral.json")}
  end

  def render("referral.json", %{referral: referral}) do
    %{id: referral.id,
      user_id: referral.user_id,
      referred_by: referral.referred_by,
      remarks: referral.remarks,
      user: render_one(referral.user, UserView, "user.json"),
      referrer: render_one(referral.referrer, UserView, "user.json")
    }
  end

  def render("error.json", %{error: message}) do
    %{error: %{detail: message}}
  end
end
