defmodule Bijakhq.Quizzes.SessionQuestion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Quizzes.QuizQuestion


  schema "quiz_session_question" do
    field :is_completed, :boolean, default: false
    field :sequence, :integer
    field :total_answered_a, :integer
    field :total_answered_b, :integer
    field :total_answered_c, :integer
    field :total_correct, :integer

    belongs_to :session, QuizSession, foreign_key: :session_id
    belongs_to :question, QuizQuestion, foreign_key: :question_id

    timestamps()
  end

  @doc false
  def changeset(session_question, attrs) do
    session_question
    |> cast(attrs, [:sequence, :is_completed, :total_answered_a, :total_answered_b, :total_answered_c, :total_correct])
    |> validate_required([:sequence, :is_completed, :total_answered_a, :total_answered_b, :total_answered_c, :total_correct])
  end
end
