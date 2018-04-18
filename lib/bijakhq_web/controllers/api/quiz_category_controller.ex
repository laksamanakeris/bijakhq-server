defmodule BijakhqWeb.Api.QuizCategoryController do
  use BijakhqWeb, :controller

  alias Bijakhq.Quizzes
  alias Bijakhq.Quizzes.QuizCategory

  action_fallback BijakhqWeb.FallbackController

  def index(conn, _params) do
    quiz_categories = Quizzes.list_quiz_categories()
    render(conn, "index.json", quiz_categories: quiz_categories)
  end

  def create(conn, %{"quiz_category" => quiz_category_params}) do
    with {:ok, %QuizCategory{} = quiz_category} <- Quizzes.create_quiz_category(quiz_category_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", api_quiz_category_path(conn, :show, quiz_category))
      |> render("show.json", quiz_category: quiz_category)
    end
  end

  def show(conn, %{"id" => id}) do
    quiz_category = Quizzes.get_quiz_category!(id)
    render(conn, "show.json", quiz_category: quiz_category)
  end

  def update(conn, %{"id" => id, "quiz_category" => quiz_category_params}) do
    quiz_category = Quizzes.get_quiz_category!(id)

    with {:ok, %QuizCategory{} = quiz_category} <- Quizzes.update_quiz_category(quiz_category, quiz_category_params) do
      render(conn, "show.json", quiz_category: quiz_category)
    end
  end

  def delete(conn, %{"id" => id}) do
    quiz_category = Quizzes.get_quiz_category!(id)
    with {:ok, %QuizCategory{}} <- Quizzes.delete_quiz_category(quiz_category) do
      send_resp(conn, :no_content, "")
    end
  end
end
