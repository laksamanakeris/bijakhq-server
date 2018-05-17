defmodule Bijakhq.Sms.Verification do

  alias Bijakhq.Sms
  alias Bijakhq.Sms.Nexmo
  alias Bijakhq.Sms.NexmoRequest

  def authenticate(phone) do

    response = Nexmo.authenticate(phone)
    IO.inspect response

    case response do
      {:ok, decoded} -> process_authenticate(phone, decoded)
      {:error, reason} -> {:error, reason}
    end
  end

  def process_authenticate(phone, %{"request_id" => request_id, "status" => "0"}) do
    with {:ok, nexmo_request} <- Sms.create_nexmo_request(%{"phone" => phone, "request_id" => request_id}) do
      IO.inspect nexmo_request
      {:ok, %{"phone" => phone, "request_id" => request_id}}
    end
  end

  def process_authenticate(phone, %{"request_id" => request_id, "error_text" => error_text} = decoded) do
    IO.inspect phone
    IO.inspect decoded
    {:error, %{"error" => error_text, "request_id" => request_id, "phone" => phone}}
  end

  # def process_authenticate(phone, {:ok, %{"status" => "0", "request_id" => request_id}}) do
  #   render(conn, "verification.json", %{data: %{phone: phone, request_id: request_id}} )
  # end

  # def process_verify(conn, _, {:ok, %{"status" => _, "error_text" => error_text}}) do
  #   render(conn, "error.json", error: error_text)
  # end

  # def process_verify(conn, _, {:error, _}) do
  #   render(conn, "error.json", error: "Error sending out SMS")
  # end

  def verify(request_id, code) do

  end

  def cancel(request_id) do

  end


end
