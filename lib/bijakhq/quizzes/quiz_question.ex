defmodule Bijakhq.Quizzes.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.QuizCategory


  schema "quiz_questions" do
    field :answer, :string
    field :optionB, :string
    field :optionC, :string
    field :question, :string

    field :selected, :boolean, default: false
    # field :category_id, :id

    belongs_to :category, QuizCategory, foreign_key: :category_id

    timestamps()
  end

  @doc false
  def changeset(quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:category_id, :question, :answer, :optionB, :optionC, :selected])
    |> validate_required([:question, :answer, :optionB, :optionC])
  end
end
