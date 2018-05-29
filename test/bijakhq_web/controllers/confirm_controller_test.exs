defmodule BijakhqWeb.ConfirmControllerTest do
  use BijakhqWeb.ConnCase

  import BijakhqWeb.AuthCase

  setup %{conn: conn} do
    add_user("arthur@example.com")
    {:ok, %{conn: conn}}
  end

  test "confirmation succeeds for correct key", %{conn: conn} do
    conn = get(conn, confirm_path(conn, :index, key: gen_key("arthur@example.com")))
    assert json_response(conn, 200)["info"]["detail"]
  end

  test "confirmation fails for incorrect key", %{conn: conn} do
    conn = get(conn, confirm_path(conn, :index, key: "garbage"))
    assert json_response(conn, 401)["errors"]["detail"]
  end

  test "confirmation fails for incorrect email", %{conn: conn} do
    conn = get(conn, confirm_path(conn, :index, key: gen_key("gerald@example.com")))
    assert json_response(conn, 401)["errors"]["detail"]
  end
end
