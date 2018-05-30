defmodule Bijakhq.Quizzes.QuizSession do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.SessionQuestion


  schema "quiz_sessions" do
    field :completed_at, :utc_datetime
    field :description, :string
    field :is_active, :boolean, default: false
    field :is_completed, :boolean, default: false
    field :name, :string
    field :prize, :string
    field :prize_description, :string
    field :time, :utc_datetime
    field :total_questions, :integer

    has_many :questions, SessionQuestion, foreign_key: :session_id

    timestamps()
  end

  @doc false
  def changeset(quiz_session, attrs) do
    quiz_session
    |> cast(attrs, [:name, :description, :prize, :prize_description, :total_questions, :time, :is_active, :is_completed, :completed_at])
    |> validate_required([:name, :description, :prize, :prize_description, :total_questions, :time, :is_active, :is_completed, :completed_at])
  end
end
