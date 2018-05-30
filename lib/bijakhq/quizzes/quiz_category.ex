defmodule Bijakhq.Quizzes.QuizCategory do
  use Ecto.Schema
  import Ecto.Changeset

  # alias Rajin.Posts.{JobCategory, Job}
  alias Bijakhq.Quizzes.QuizQuestion


  schema "quiz_categories" do
    field :description, :string
    field :title, :string

    has_many :questions, QuizQuestion, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(quiz_category, attrs) do
    quiz_category
    |> cast(attrs, [:title, :description])
    |> validate_required([:title])
    |> unique_title
  end

  defp unique_title(changeset) do
    validate_length(changeset, :title, min: 3)
    |> unique_constraint(:title)
  end
end
