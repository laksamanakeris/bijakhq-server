defmodule BijakhqWeb.Api.VerificationController do
  use BijakhqWeb, :controller

  import BijakhqWeb.Api.Authorize
  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.User
  alias Bijakhq.Sms
  alias Bijakhq.Sms.{Nexmo, NexmoRequest}

  plug :guest_check when action in [:verify]

  action_fallback Bijakhq.Api.FallbackController

  def authenticate(conn, %{"phone" => phone} = params) do
    IO.inspect params
    IO.puts "Phone number #{phone}"

    response = Nexmo.authenticate(phone);

    case response do
      {:ok, _} -> process_auth(conn, phone, response);
      {:error, data} -> process_auth_error(conn, data)
    end
  end

  defp process_auth(conn, phone, response ) do
    case response do
      {:ok, %{"status" => "0"} = decoded} ->
        %{"request_id" => request_id } = decoded
        with {:ok, nexmo_request} <- Sms.create_nexmo_request(%{"phone" => phone, "request_id" => request_id}) do
          IO.inspect nexmo_request
          render(conn, "authentication.json", %{data: %{phone: phone, request_id: request_id} } )
        end
      {:ok, %{"error_text" => error_text, "request_id" => request_id, "status" => status} } ->
        IO.inspect request_id
        IO.inspect status
        render(conn, "error.json", error: error_text)
    end
  end

  defp process_auth_error(conn, _) do
    render(conn, "error.json", error: "Error sending out SMS")
  end

  # ================================================================================

  def verify(conn, %{"request_id" => request_id, "code" => code} = params) do
    IO.inspect params

    response = Nexmo.verify(request_id, code)
    IO.inspect response

    case response do
      {:ok, %{"request_id" => request_id, "status" => "0"} = params } ->
        # get nexmo request by request ID
        # update nexmo request
        # create tokens & login
        IO.inspect params
        nexmo_request = Sms.get_nexmo_request_by!(%{request_id: request_id})
        case nexmo_request do
          nil ->
            render(conn, "error.json", error: "Request ID is not recognised")
          _ ->
            Sms.verify_request(nexmo_request)
            # check if phone exist in users table
            %{phone: phone} = nexmo_request
            user = Accounts.get_by(%{"phone" => phone})
            case user do
              nil ->
                render(conn, "verified_new_user.json", %{data: nil} )
              _ ->
                logged_in_user(conn, user, nexmo_request)
            end
            render(conn, "authentication.json", %{data: %{phone: phone, request_id: request_id} } )
        end
      {:ok, %{"error_text" => error_text, "status" => status}} ->
        IO.inspect status
        render(conn, "error.json", error: error_text)
      {:error, error} ->
        IO.inspect error
        render(conn, "error.json", error: "Error sending out SMS")
    end
  end

  def logged_in_user( conn, user, nexmo_request) do
    Sms.update_nexmo_request(nexmo_request, %{is_completed: true, completed_at: DateTime.utc_now})
    token = Phauxth.Token.sign(conn, user.id)
    # render(conn, "verified_user.json", %{info: token, user: user})
    render(conn, BijakhqWeb.Api.VerificationView, "verified_user.json", %{info: token, user: user})
  end

  def cancel(conn, %{"request_id" => request_id} = params) do
    IO.inspect params
    IO.inspect request_id

    Nexmo.cancel_next_request(request_id)

    render(conn, "verify_result.json", %{data: %{request_id: request_id}} )
  end
end
