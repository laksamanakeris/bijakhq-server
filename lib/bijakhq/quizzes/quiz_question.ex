defmodule Bijakhq.Quizzes.QuizQuestion do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.QuizCategory
  alias Bijakhq.Quizzes.QuizSession


  schema "quiz_questions" do
    field :answer, :string
    field :optionB, :string
    field :optionC, :string
    field :question, :string

    field :selected, :boolean, default: false
    # field :category_id, :id
    field :description, :string

    belongs_to :category, QuizCategory, foreign_key: :category_id
    # has_many :games, QuizGameQuestion, foreign_key: :user_id
    many_to_many :games, QuizSession, join_through: "quiz_session_question", join_keys: [question_id: :id, session_id: :id]

    timestamps()
  end

  @doc false
  def changeset(quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:category_id, :question, :answer, :optionB, :optionC, :selected, :description])
    |> validate_required([:question, :answer, :optionB, :optionC])
  end
end
