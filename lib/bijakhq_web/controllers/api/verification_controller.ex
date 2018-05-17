defmodule BijakhqWeb.Api.VerificationController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Sms.Nexmo
  alias Bijakhq.Sms.Verification

  plug :guest_check when action in [:verify]

  action_fallback Bijakhq.Api.FallbackController

  def authenticate(conn, %{"phone" => phone} = params) do
    IO.inspect params
    IO.puts "Phone number #{phone}"

    response = Verification.authenticate(phone)

    case response do
      {:ok, data} -> process_auth(conn, phone, data);
      {:error, data} -> process_auth_error(conn, data)
    end
  end

  defp process_auth(conn, phone, %{"request_id" => request_id, "status" => "0" } ) do
    render(conn, "authentication.json", %{data: %{phone: phone, request_id: request_id} } )
  end

  defp process_auth_error(conn, %{"error" => error}) do
    render(conn, "error.json", error: error)
  end

  defp process_auth_error(conn, _) do
    render(conn, "error.json", error: "Error sending out SMS")
  end

  def verify(conn, %{"request_id" => request_id, "code" => code} = params) do
    IO.inspect request_id
    IO.inspect params

    response = Verification.verify(request_id, code)

    IO.inspect response

    render(conn, "verify_result.json", %{data: %{request_id: request_id}} )
  end

  def cancel(conn, %{"request_id" => request_id} = params) do
    IO.inspect params
    IO.inspect request_id

    response = Verification.cancel(request_id)

    render(conn, "verify_result.json", %{data: %{request_id: request_id}} )
  end
end
