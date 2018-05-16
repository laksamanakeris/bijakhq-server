defmodule BijakhqWeb.Api.VerificationController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Sms.Nexmo
  alias Bijakhq.Sms.Verification

  plug :guest_check when action in [:verify]

  action_fallback Bijakhq.Api.FallbackController

  def verify(conn, %{"phone" => phone} = params) do
    IO.inspect params
    IO.puts "Phone number #{phone}"

    response = Verification.authenticate(phone)
    IO.inspect response

    process_verify(conn, phone, response);
  end

  def process_verify(conn, phone, {:ok, %{"status" => "0", "request_id" => request_id}}) do
    render(conn, "verification.json", %{data: %{phone: phone, request_id: request_id}} )
  end

  def process_verify(conn, _, {:ok, %{"status" => _, "error_text" => error_text}}) do
    render(conn, "error.json", error: error_text)
  end

  def process_verify(conn, _, {:error, _}) do
    render(conn, "error.json", error: "Error sending out SMS")
  end

  def verify_request(conn, %{"request_id" => request_id, "code" => code} = params) do
    IO.inspect request_id
    IO.inspect params

    response = Nexmo.verify(request_id, code)

    IO.inspect response

    render(conn, "verify_result.json", %{data: %{request_id: request_id}} )
  end

  def cancel_request(conn, %{"request_id" => request_id} = params) do
    IO.inspect params
    IO.inspect request_id
    render(conn, "verify_result.json", %{data: %{request_id: request_id}} )
  end
end
