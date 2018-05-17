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
end
