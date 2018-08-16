defmodule BijakhqWeb.ReferralControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.Referral

  @create_attrs %{referred_by: 42, remarks: "some remarks", user_id: 42}
  @update_attrs %{referred_by: 43, remarks: "some updated remarks", user_id: 43}
  @invalid_attrs %{referred_by: nil, remarks: nil, user_id: nil}

  def fixture(:referral) do
    {:ok, referral} = Accounts.create_referral(@create_attrs)
    referral
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all referrals", %{conn: conn} do
      conn = get conn, referral_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create referral" do
    test "renders referral when data is valid", %{conn: conn} do
      conn = post conn, referral_path(conn, :create), referral: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, referral_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "referred_by" => 42,
        "remarks" => "some remarks",
        "user_id" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, referral_path(conn, :create), referral: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update referral" do
    setup [:create_referral]

    test "renders referral when data is valid", %{conn: conn, referral: %Referral{id: id} = referral} do
      conn = put conn, referral_path(conn, :update, referral), referral: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, referral_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "referred_by" => 43,
        "remarks" => "some updated remarks",
        "user_id" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, referral: referral} do
      conn = put conn, referral_path(conn, :update, referral), referral: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete referral" do
    setup [:create_referral]

    test "deletes chosen referral", %{conn: conn, referral: referral} do
      conn = delete conn, referral_path(conn, :delete, referral)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, referral_path(conn, :show, referral)
      end
    end
  end

  defp create_referral(_) do
    referral = fixture(:referral)
    {:ok, referral: referral}
  end
end
