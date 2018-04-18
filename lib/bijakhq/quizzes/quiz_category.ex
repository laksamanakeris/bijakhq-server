defmodule Bijakhq.Quizzes.QuizCategory do
  use Ecto.Schema
  import Ecto.Changeset


  schema "quiz_categories" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(quiz_category, attrs) do
    quiz_category
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
