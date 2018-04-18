defmodule BijakhqWeb.QuizCategoryView do
  use BijakhqWeb, :view
  alias BijakhqWeb.Api.QuizCategoryView

  def render("index.json", %{quiz_categories: quiz_categories}) do
    %{data: render_many(quiz_categories, QuizCategoryView, "quiz_category.json")}
  end

  def render("show.json", %{quiz_category: quiz_category}) do
    %{data: render_one(quiz_category, QuizCategoryView, "quiz_category.json")}
  end

  def render("quiz_category.json", %{quiz_category: quiz_category}) do
    %{id: quiz_category.id,
      title: quiz_category.title,
      description: quiz_category.description}
  end
end
