defmodule Bijakhq.Quizzes.QuizScore do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Accounts.User


  schema "quiz_scores" do

    field :amount, :float
    field :completed_at, :utc_datetime
    # field :category_id, :id

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :game, QuizSession, foreign_key: :game_id

    timestamps()
  end

  @doc false
  def changeset(quiz_question, attrs) do
    quiz_question
    |> cast(attrs, [:amount, :completed_at, :user_id, :game_id])
    |> validate_required([:amount, :completed_at, :user_id, :game_id])
  end
end
