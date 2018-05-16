defmodule Bijakhq.Sms.Verification do

  alias Bijakhq.Sms.Nexmo

  def authenticate(phone) do

  end

  # def process_authenticate(conn, phone, {:ok, %{"status" => "0", "request_id" => request_id}}) do
  #   render(conn, "verification.json", %{data: %{phone: phone, request_id: request_id}} )
  # end

  # def process_verify(conn, _, {:ok, %{"status" => _, "error_text" => error_text}}) do
  #   render(conn, "error.json", error: error_text)
  # end

  # def process_verify(conn, _, {:error, _}) do
  #   render(conn, "error.json", error: "Error sending out SMS")
  # end

  def verify(request_id) do

  end

  def cancel(request_id) do

  end


end
