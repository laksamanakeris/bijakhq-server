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

  describe "payment_types" do
    alias Bijakhq.Payments.PaymentType

    @valid_attrs %{configuration: "some configuration", description: "some description", name: "some name"}
    @update_attrs %{configuration: "some updated configuration", description: "some updated description", name: "some updated name"}
    @invalid_attrs %{configuration: nil, description: nil, name: nil}

    def payment_type_fixture(attrs \\ %{}) do
      {:ok, payment_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment_type()

      payment_type
    end

    test "list_payment_types/0 returns all payment_types" do
      payment_type = payment_type_fixture()
      assert Payments.list_payment_types() == [payment_type]
    end

    test "get_payment_type!/1 returns the payment_type with given id" do
      payment_type = payment_type_fixture()
      assert Payments.get_payment_type!(payment_type.id) == payment_type
    end

    test "create_payment_type/1 with valid data creates a payment_type" do
      assert {:ok, %PaymentType{} = payment_type} = Payments.create_payment_type(@valid_attrs)
      assert payment_type.configuration == "some configuration"
      assert payment_type.description == "some description"
      assert payment_type.name == "some name"
    end

    test "create_payment_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_type(@invalid_attrs)
    end

    test "update_payment_type/2 with valid data updates the payment_type" do
      payment_type = payment_type_fixture()
      assert {:ok, payment_type} = Payments.update_payment_type(payment_type, @update_attrs)
      assert %PaymentType{} = payment_type
      assert payment_type.configuration == "some updated configuration"
      assert payment_type.description == "some updated description"
      assert payment_type.name == "some updated name"
    end

    test "update_payment_type/2 with invalid data returns error changeset" do
      payment_type = payment_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment_type(payment_type, @invalid_attrs)
      assert payment_type == Payments.get_payment_type!(payment_type.id)
    end

    test "delete_payment_type/1 deletes the payment_type" do
      payment_type = payment_type_fixture()
      assert {:ok, %PaymentType{}} = Payments.delete_payment_type(payment_type)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_type!(payment_type.id) end
    end

    test "change_payment_type/1 returns a payment_type changeset" do
      payment_type = payment_type_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_type(payment_type)
    end
  end

  describe "payment_batches" do
    alias Bijakhq.Payments.PaymentBatch

    @valid_attrs %{date_processed: ~N[2010-04-17 14:00:00.000000], description: "some description", is_processed: true}
    @update_attrs %{date_processed: ~N[2011-05-18 15:01:01.000000], description: "some updated description", is_processed: false}
    @invalid_attrs %{date_processed: nil, description: nil, is_processed: nil}

    def payment_batch_fixture(attrs \\ %{}) do
      {:ok, payment_batch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment_batch()

      payment_batch
    end

    test "list_payment_batches/0 returns all payment_batches" do
      payment_batch = payment_batch_fixture()
      assert Payments.list_payment_batches() == [payment_batch]
    end

    test "get_payment_batch!/1 returns the payment_batch with given id" do
      payment_batch = payment_batch_fixture()
      assert Payments.get_payment_batch!(payment_batch.id) == payment_batch
    end

    test "create_payment_batch/1 with valid data creates a payment_batch" do
      assert {:ok, %PaymentBatch{} = payment_batch} = Payments.create_payment_batch(@valid_attrs)
      assert payment_batch.date_processed == ~N[2010-04-17 14:00:00.000000]
      assert payment_batch.description == "some description"
      assert payment_batch.is_processed == true
    end

    test "create_payment_batch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_batch(@invalid_attrs)
    end

    test "update_payment_batch/2 with valid data updates the payment_batch" do
      payment_batch = payment_batch_fixture()
      assert {:ok, payment_batch} = Payments.update_payment_batch(payment_batch, @update_attrs)
      assert %PaymentBatch{} = payment_batch
      assert payment_batch.date_processed == ~N[2011-05-18 15:01:01.000000]
      assert payment_batch.description == "some updated description"
      assert payment_batch.is_processed == false
    end

    test "update_payment_batch/2 with invalid data returns error changeset" do
      payment_batch = payment_batch_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment_batch(payment_batch, @invalid_attrs)
      assert payment_batch == Payments.get_payment_batch!(payment_batch.id)
    end

    test "delete_payment_batch/1 deletes the payment_batch" do
      payment_batch = payment_batch_fixture()
      assert {:ok, %PaymentBatch{}} = Payments.delete_payment_batch(payment_batch)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_batch!(payment_batch.id) end
    end

    test "change_payment_batch/1 returns a payment_batch changeset" do
      payment_batch = payment_batch_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_batch(payment_batch)
    end
  end

  describe "payment_batch_items" do
    alias Bijakhq.Payments.PaymentBatchItem

    @valid_attrs %{batch_id: 42, payment_id: 42, status: 42}
    @update_attrs %{batch_id: 43, payment_id: 43, status: 43}
    @invalid_attrs %{batch_id: nil, payment_id: nil, status: nil}

    def payment_batch_item_fixture(attrs \\ %{}) do
      {:ok, payment_batch_item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payments.create_payment_batch_item()

      payment_batch_item
    end

    test "list_payment_batch_items/0 returns all payment_batch_items" do
      payment_batch_item = payment_batch_item_fixture()
      assert Payments.list_payment_batch_items() == [payment_batch_item]
    end

    test "get_payment_batch_item!/1 returns the payment_batch_item with given id" do
      payment_batch_item = payment_batch_item_fixture()
      assert Payments.get_payment_batch_item!(payment_batch_item.id) == payment_batch_item
    end

    test "create_payment_batch_item/1 with valid data creates a payment_batch_item" do
      assert {:ok, %PaymentBatchItem{} = payment_batch_item} = Payments.create_payment_batch_item(@valid_attrs)
      assert payment_batch_item.batch_id == 42
      assert payment_batch_item.payment_id == 42
      assert payment_batch_item.status == 42
    end

    test "create_payment_batch_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_payment_batch_item(@invalid_attrs)
    end

    test "update_payment_batch_item/2 with valid data updates the payment_batch_item" do
      payment_batch_item = payment_batch_item_fixture()
      assert {:ok, payment_batch_item} = Payments.update_payment_batch_item(payment_batch_item, @update_attrs)
      assert %PaymentBatchItem{} = payment_batch_item
      assert payment_batch_item.batch_id == 43
      assert payment_batch_item.payment_id == 43
      assert payment_batch_item.status == 43
    end

    test "update_payment_batch_item/2 with invalid data returns error changeset" do
      payment_batch_item = payment_batch_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_payment_batch_item(payment_batch_item, @invalid_attrs)
      assert payment_batch_item == Payments.get_payment_batch_item!(payment_batch_item.id)
    end

    test "delete_payment_batch_item/1 deletes the payment_batch_item" do
      payment_batch_item = payment_batch_item_fixture()
      assert {:ok, %PaymentBatchItem{}} = Payments.delete_payment_batch_item(payment_batch_item)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_payment_batch_item!(payment_batch_item.id) end
    end

    test "change_payment_batch_item/1 returns a payment_batch_item changeset" do
      payment_batch_item = payment_batch_item_fixture()
      assert %Ecto.Changeset{} = Payments.change_payment_batch_item(payment_batch_item)
    end
  end
end
