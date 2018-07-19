defmodule Bijakhq.Quizzes.SessionQuestion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Quizzes.QuizQuestion


  schema "quiz_session_question" do
    field :is_completed, :boolean, default: false
    field :sequence, :integer

    field :total_correct, :integer

    field :answers_sequence, :map, default: %{}
    field :answers_totals, :map, default: %{}

    belongs_to :session, QuizSession, foreign_key: :session_id
    belongs_to :question, QuizQuestion, foreign_key: :question_id

    timestamps()
  end

  @doc false
  def changeset(session_question, attrs) do
    session_question
    |> cast(attrs, [:sequence, :is_completed, :total_correct, :answers_sequence, :answers_totals])
    |> validate_required([:sequence, :is_completed, :total_correct])
  end

  def changeset_create(session_question, attrs) do
    session_question
    |> cast(attrs, [:session_id, :question_id])
    |> validate_required([:session_id, :question_id])
  end
end
