defmodule Bijakhq.Payments.Paypal do

  alias Bijakhq.Repo
  alias Bijakhq.Payments
  alias Bijakhq.Payments.PaymentBatch

  alias Bijakhq.Payments.Paypal

  
  def process_batch_id(batch_id) do

    batch = Payments.get_payment_batch!(batch_id) |> Repo.preload(items: :payment)
    #IO.inspect batch

    header = Paypal.create_header(batch)
    items = Paypal.create_items(batch.items)

    %{sender_batch_header: header, items: items}
    
  end

  def create_header(batch) do
    %{
      sender_batch_id: batch.id,
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
        currency: "RM"
      },
      note: "Thanks for playing BijakTrivia!",
      sender_item_id: item.ref_id,
      receiver: item.payment.paypal_email
    }
  end
  
end