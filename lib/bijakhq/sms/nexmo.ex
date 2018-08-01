defmodule Bijakhq.Sms.Nexmo do

  @nexmo_url "https://api.nexmo.com/verify"
  @api_key "380f9c4d"
  @api_secret "9ac0a59b360a3649"
  @brand "Bijak Trivia"
  @headers [{"content-type", "application/json; charset=utf-8"}]
  @pin_expiry 60 * 5

  def authenticate(phone_number) do
    request = "/json"
    url = @nexmo_url <> request

    body = Poison.encode!(%{
      "api_key": @api_key,
      "api_secret": @api_secret,
      "brand": @brand,
      "pin_expiry": @pin_expiry,
      "number": phone_number
    })

    HTTPoison.post(url, body, @headers)
    |> handle_send_reponse

  end

  @spec handle_send_reponse({atom, HTTPoison.Response.t}) :: {atom, Response.t} | {atom, String.t}
  defp handle_send_reponse({:ok, %HTTPoison.Response{body: body, status_code: 200} }) do
    # HTTP status 200 (OK) and we have a body
    case Poison.decode(body) do
      {:ok, decoded} -> {:ok, decoded}
      {:error, error} -> {:error, error}
    end
  end

  defp handle_send_reponse({:error, %HTTPoison.Error{id: _id, reason: reason}}) do
    {:error, reason}
  end

  def verify(request_id, code) do
    request = "/check/json"
    url = @nexmo_url <> request

    body = Poison.encode!(%{
      "api_key": @api_key,
      "api_secret": @api_secret,
      "request_id": request_id,
      "code": code
    })

    HTTPoison.post(url, body, @headers)
    |> handle_send_reponse
  end

  def cancel_next_request( request_id) do

    request = "/control/json"
    url = @nexmo_url <> request

    body = Poison.encode!(%{
      "api_key": @api_key,
      "api_secret": @api_secret,
      "request_id": request_id,
      "cmd": "cancel"
    })

    HTTPoison.post(url, body, @headers)
    |> handle_send_reponse
  end

end
