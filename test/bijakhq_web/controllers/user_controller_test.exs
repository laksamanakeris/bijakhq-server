defmodule BijakhqWeb.UserControllerTest do
  use BijakhqWeb.ConnCase

  import BijakhqWeb.AuthCase
  alias Bijakhq.Accounts

  @create_attrs %{email: "bill@example.com", password: "hard2guess"}
  @update_attrs %{email: "william@example.com"}
  @invalid_attrs %{email: nil}

  # setup %{conn: conn} = config do
  #   if email = config[:login] do
  #     user = add_user(email)
  #     other = add_user("tony@example.com")
  #     conn = conn |> add_token_conn(user)
  #     {:ok, %{conn: conn, user: user, other: other}}
  #   else
  #     {:ok, %{conn: conn}}
  #   end
  # end

  # @tag login: "reg@example.com"
  # test "lists all entries on index", %{conn: conn} do
  #   conn = get(conn, user_path(conn, :index))
  #   assert json_response(conn, 200)
  # end

  # test "renders /users error for unauthorized user", %{conn: conn}  do
  #   conn = get(conn, user_path(conn, :index))
  #   assert json_response(conn, 401)
  # end

  # @tag login: "reg@example.com"
  # test "show chosen user's page", %{conn: conn, user: user} do
  #   conn = get(conn, user_path(conn, :show, user))
  #   assert json_response(conn, 200)["data"] == %{"id" => user.id, "email" => "reg@example.com"}
  # end

  # test "creates user when data is valid", %{conn: conn} do
  #   conn = post(conn, user_path(conn, :create), user: @create_attrs)
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Accounts.get_by(%{"email" => "bill@example.com"})
  # end

  # test "does not create user and renders errors when data is invalid", %{conn: conn} do
  #   conn = post(conn, user_path(conn, :create), user: @invalid_attrs)
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # @tag login: "reg@example.com"
  # test "updates chosen user when data is valid", %{conn: conn, user: user} do
  #   conn = put(conn, user_path(conn, :update, user), user: @update_attrs)
  #   assert json_response(conn, 200)["data"]["id"] == user.id
  #   updated_user = Accounts.get(user.id)
  #   assert updated_user.email == "william@example.com"
  # end

  # @tag login: "reg@example.com"
  # test "does not update chosen user and renders errors when data is invalid", %{conn: conn, user: user} do
  #   conn = put(conn, user_path(conn, :update, user), user: @invalid_attrs)
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # @tag login: "reg@example.com"
  # test "deletes chosen user", %{conn: conn, user: user} do
  #   conn = delete(conn, user_path(conn, :delete, user))
  #   assert response(conn, 204)
  #   refute Accounts.get(user.id)
  # end

  # @tag login: "reg@example.com"
  # test "cannot delete other user", %{conn: conn, other: other} do
  #   conn = delete(conn, user_path(conn, :delete, other))
  #   assert json_response(conn, 403)["errors"]["detail"] =~ "not authorized"
  #   assert Accounts.get(other.id)
  # end
end
