defmodule BijakhqWeb.Api.QuizCategoryControllerTest do
  use BijakhqWeb.ConnCase

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizCategory

  # @create_attrs %{description: "some description", title: "some title"}
  # @update_attrs %{description: "some updated description", title: "some updated title"}
  # @invalid_attrs %{description: nil, title: nil}

  # def fixture(:quiz_category) do
  #   {:ok, quiz_category} = Quizzes.create_quiz_category(@create_attrs)
  #   quiz_category
  # end

  # setup %{conn: conn} do
  #   {:ok, conn: put_req_header(conn, "accept", "application/json")}
  # end

  # describe "index" do
  #   test "lists all quiz_categories", %{conn: conn} do
  #     conn = get conn, api_quiz_category_path(conn, :index)
  #     assert json_response(conn, 200)["data"] == []
  #   end
  # end

  # describe "create quiz_category" do
  #   test "renders quiz_category when data is valid", %{conn: conn} do
  #     conn = post conn, api_quiz_category_path(conn, :create), quiz_category: @create_attrs
  #     assert %{"id" => id} = json_response(conn, 201)["data"]

  #     conn = get conn, api_quiz_category_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "description" => "some description",
  #       "title" => "some title"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn} do
  #     conn = post conn, api_quiz_category_path(conn, :create), quiz_category: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "update quiz_category" do
  #   setup [:create_quiz_category]

  #   test "renders quiz_category when data is valid", %{conn: conn, quiz_category: %QuizCategory{id: id} = quiz_category} do
  #     conn = put conn, api_quiz_category_path(conn, :update, quiz_category), quiz_category: @update_attrs
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get conn, api_quiz_category_path(conn, :show, id)
  #     assert json_response(conn, 200)["data"] == %{
  #       "id" => id,
  #       "description" => "some updated description",
  #       "title" => "some updated title"}
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, quiz_category: quiz_category} do
  #     conn = put conn, api_quiz_category_path(conn, :update, quiz_category), quiz_category: @invalid_attrs
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete quiz_category" do
  #   setup [:create_quiz_category]

  #   test "deletes chosen quiz_category", %{conn: conn, quiz_category: quiz_category} do
  #     conn = delete conn, api_quiz_category_path(conn, :delete, quiz_category)
  #     assert response(conn, 204)
  #     assert_error_sent 404, fn ->
  #       get conn, api_quiz_category_path(conn, :show, quiz_category)
  #     end
  #   end
  # end

  # defp create_quiz_category(_) do
  #   quiz_category = fixture(:quiz_category)
  #   {:ok, quiz_category: quiz_category}
  # end
end
