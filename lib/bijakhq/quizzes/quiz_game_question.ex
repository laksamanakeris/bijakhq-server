defmodule Bijakhq.Quizzes.QuizGameQuestion do
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
  def changeset(game_question, attrs) do
    game_question
    |> cast(attrs, [:sequence, :is_completed, :total_correct, :answers_sequence, :answers_totals])
    |> validate_required([:sequence])
  end

  def changeset_create(game_question, attrs) do
    game_question
    |> cast(attrs, [:session_id, :question_id, :sequence])
    |> validate_required([:session_id, :question_id, :sequence])
    |> unique_constraint(:game_id_question_id, name: :game_question_unique)
  end
end
