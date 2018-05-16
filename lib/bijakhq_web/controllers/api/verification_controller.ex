defmodule BijakhqWeb.Api.VerificationController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.SMS.Nexmo

  plug :guest_check when action in [:verify]

  action_fallback Bijakhq.Api.FallbackController

  def verify(conn, %{"phone" => phone} = params) do
    IO.inspect params
    IO.puts "Phone number #{phone}"

    response = Nexmo.authenticate(phone)

    IO.inspect response

    render(conn, "verification.json", phone: phone)
  end
end
