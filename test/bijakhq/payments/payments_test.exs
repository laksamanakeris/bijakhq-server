defmodule Bijakhq.PaymentsTest do
  use Bijakhq.DataCase

  alias Bijakhq.Payments

  describe "payments" do
    alias Bijakhq.Payments.Payment

    @valid_attrs %{amount: 120.5, payment_at: "2010-04-17 14:00:00.000000Z", remarks: "some remarks", updated_by: 42, user_id: 42}
    @update_attrs %{amount: 456.7, payment_at: "2011-05-18 15:01:01.000000Z", remarks: "some updated remarks", updated_by: 43, user_id: 43}
    @invalid_attrs %{amount: nil, payment_at: nil, remarks: nil, updated_by: nil, user_id: nil}

    def payment_fixture(attrs \\ %{}) do
      {:ok, payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment()

      payment
    end

    test "list_payments/0 returns all payments" do
      payment = payment_fixture()
      assert Payments.list_payments() == [payment]
    end

    test "get_payment!/1 returns the payment with given id" do
      payment = payment_fixture()
      assert Payments.get_payment!(payment.id) == payment
    end

    test "create_payment/1 with valid data creates a payment" do
      assert {:ok, %Payment{} = payment} = Payments.create_payment(@valid_attrs)
      assert payment.amount == 120.5
      assert payment.payment_at == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
      assert payment.remarks == "some remarks"
      assert payment.updated_by == 42
      assert payment.user_id == 42
    end

    test "create_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment(@invalid_attrs)
    end

    test "update_payment/2 with valid data updates the payment" do
      payment = payment_fixture()
      assert {:ok, payment} = Payments.update_payment(payment, @update_attrs)
      assert %Payment{} = payment
      assert payment.amount == 456.7
      assert payment.payment_at == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
      assert payment.remarks == "some updated remarks"
      assert payment.updated_by == 43
      assert payment.user_id == 43
    end

    test "update_payment/2 with invalid data returns error changeset" do
      payment = payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment(payment, @invalid_attrs)
      assert payment == Payments.get_payment!(payment.id)
    end

    test "delete_payment/1 deletes the payment" do
      payment = payment_fixture()
      assert {:ok, %Payment{}} = Payments.delete_payment(payment)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment!(payment.id) end
    end

    test "change_payment/1 returns a payment changeset" do
      payment = payment_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment(payment)
    end
  end

  describe "payment_statuses" do
    alias Bijakhq.Payments.PaymentStatus

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def payment_status_fixture(attrs \\ %{}) do
      {:ok, payment_status} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment_status()

      payment_status
    end

    test "list_payment_statuses/0 returns all payment_statuses" do
      payment_status = payment_status_fixture()
      assert Payments.list_payment_statuses() == [payment_status]
    end

    test "get_payment_status!/1 returns the payment_status with given id" do
      payment_status = payment_status_fixture()
      assert Payments.get_payment_status!(payment_status.id) == payment_status
    end

    test "create_payment_status/1 with valid data creates a payment_status" do
      assert {:ok, %PaymentStatus{} = payment_status} = Payments.create_payment_status(@valid_attrs)
      assert payment_status.description == "some description"
      assert payment_status.name == "some name"
    end

    test "create_payment_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_status(@invalid_attrs)
    end

    test "update_payment_status/2 with valid data updates the payment_status" do
      payment_status = payment_status_fixture()
      assert {:ok, payment_status} = Payments.update_payment_status(payment_status, @update_attrs)
      assert %PaymentStatus{} = payment_status
      assert payment_status.description == "some updated description"
      assert payment_status.name == "some updated name"
    end

    test "update_payment_status/2 with invalid data returns error changeset" do
      payment_status = payment_status_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment_status(payment_status, @invalid_attrs)
      assert payment_status == Payments.get_payment_status!(payment_status.id)
    end

    test "delete_payment_status/1 deletes the payment_status" do
      payment_status = payment_status_fixture()
      assert {:ok, %PaymentStatus{}} = Payments.delete_payment_status(payment_status)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_status!(payment_status.id) end
    end

    test "change_payment_status/1 returns a payment_status changeset" do
      payment_status = payment_status_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_status(payment_status)
    end
  end
end
