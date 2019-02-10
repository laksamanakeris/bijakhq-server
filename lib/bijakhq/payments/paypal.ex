defmodule Bijakhq.Payments.Paypal do

  alias Bijakhq.Repo
  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatch

  alias Bijakhq.Payments.Paypal

  
  def process_batch_id(batch_id) do
    payload = Paypal.prepare_payload(batch_id)
  end

  def prepare_payload(batch_id) do
    batch = Payments.get_payment_batch!(batch_id) |> Repo.preload(items: :payment)
    #IO.inspect batch

    header = Paypal.create_header(batch)
    items = Paypal.create_items(batch.items)

    %{sender_batch_header: header, items: items}
    
  end

  def create_header(batch) do
    %{
      sender_batch_id: batch.name,
      email_subject: "You have a payout!",
      email_message: "You have received a payment! Thanks for playing BijakTrivia!"
    }
  end

  def create_items(items) do
    list = 
      Enum.map(items, fn x -> 
        Paypal.create_item(x)
      end)
  end

  def create_item(item) do
    %{
      recipient_type: "EMAIL",
      amount: %{
        value: Float.to_string(item.payment.amount, decimals: 2),
        currency: "MYR"
      },
      note: "Thanks for playing BijakTrivia!",
      sender_item_id: item.ref_id,
      receiver: item.payment.paypal_email
    }
  end

  # process payout batch response
  # %{
  #   batch_header: %{
  #     batch_status: "PENDING",
  #     payout_batch_id: "NJBA6EWB3NJVL",
  #     sender_batch_header: %{
  #       email_message: "You have received a payment! Thanks for playing BijakTrivia!",
  #       email_subject: "You have a payout!",
  #       sender_batch_id: "batch_20190210_0625"
  #     }
  #   },
  #   links: [
  #     %{
  #       encType: "application/json",
  #       href: "https://api.sandbox.paypal.com/v1/payments/payouts/NJBA6EWB3NJVL",
  #       method: "GET",
  #       rel: "self"
  #     }
  #   ]
  # }
  def process_payout_batch_response(response) do
    sender_batch_id = response.batch_header.sender_batch_header.sender_batch_id
    batch_status = response.batch_header.batch_status
    payout_batch_id = response.batch_header.payout_batch_id

    batch = Repo.get_by(PaymentBatch, name: sender_batch_id)
    case batch do
      nil -> nil
      _ ->
        batch
        |> Ecto.Changeset.change(%{batch_status: batch_status, payout_batch_id: payout_batch_id, is_processed: true, date_processed: DateTime.utc_now})
        |> Repo.update
    end
  end

  def update_payout_batch_status(response) do
    sender_batch_id = response.batch_header.sender_batch_header.sender_batch_id
    batch_status = response.batch_header.batch_status
    amount = response.batch_header.amount.value
    fees = response.batch_header.fees.value

    {amount, _} = Float.parse(amount)
    {fees, _} = Float.parse(fees)

    batch = Repo.get_by(PaymentBatch, name: sender_batch_id)
    case batch do
      nil -> nil
      _ ->
        batch
        |> Ecto.Changeset.change(%{batch_status: batch_status, amount: amount, fees: fees})
        |> Repo.update
    end
  end
  
end