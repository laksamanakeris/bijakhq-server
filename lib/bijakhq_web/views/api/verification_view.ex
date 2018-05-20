defmodule BijakhqWeb.Api.VerificationView do
  use BijakhqWeb, :view

  def render("error.json", %{error: message}) do
    %{errors: %{details: message}}
  end

  def render("authentication.json", %{data: %{phone: phone, request_id: request_id}}) do
    %{phone: phone, request_id: request_id}
  end

  def render("verify_result.json", %{data: %{request_id: request_id}}) do
    %{request_id: request_id}
  end

  # Verification process complete
  def render("verified_user.json", %{data: auth}) do
    %{auth: "user exist"}
  end

  def render("verified_new_user.json", _) do
    %{auth: nil}
  end
end
