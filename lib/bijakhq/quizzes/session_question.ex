defmodule Bijakhq.Quizzes.SessionQuestion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Quizzes.QuizQuestion


  schema "quiz_session_question" do
    field :is_completed, :boolean, default: false
    field :sequence, :integer

    field :sequence_answer_a, :integer
    field :sequence_answer_b, :integer
    field :sequence_answer_c, :integer

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
    |> cast(attrs, [:sequence, :is_completed, :total_answered_a, :sequence_answer_a, :sequence_answer_b, :sequence_answer_c, :total_answered_b, :total_answered_c, :total_correct])
    |> validate_required([:sequence, :is_completed, :total_answered_a, :total_answered_b, :total_answered_c, :total_correct])
  end

  def changeset_create(session_question, attrs) do
    session_question
    |> cast(attrs, [:session_id, :question_id])
    |> validate_required([:session_id, :question_id])
  end
end
