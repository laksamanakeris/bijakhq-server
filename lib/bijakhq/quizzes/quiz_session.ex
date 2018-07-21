defmodule Bijakhq.Quizzes.QuizSession do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.QuizQuestion



  schema "quiz_sessions" do
    field :completed_at, :utc_datetime
    field :description, :string
    field :is_active, :boolean, default: false
    field :is_completed, :boolean, default: false
    field :name, :string
    field :prize, :integer
    field :prize_description, :string
    field :time, :utc_datetime
    field :total_questions, :integer

    # has_many :questions, SessionQuestion, foreign_key: :session_id
    many_to_many :questions, QuizQuestion, join_through: "quiz_session_question"

    timestamps()
  end

  @doc false
  def changeset(quiz_session, attrs) do
    quiz_session
    |> cast(attrs, [:name, :description, :prize, :prize_description, :total_questions, :time, :is_active, :is_completed, :completed_at])
    |> validate_required([:name, :prize, :total_questions, :time])
  end
end