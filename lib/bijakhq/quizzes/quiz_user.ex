defmodule Bijakhq.Quizzes.QuizUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias Bijakhq.Quizzes.QuizSession
  alias Bijakhq.Accounts.User


  schema "quiz_game_users" do
    field :is_player, :boolean, default: false
    field :is_viewer, :boolean, default: false

    belongs_to :user, User, foreign_key: :user_id
    belongs_to :game, QuizSession, foreign_key: :game_id
    
    timestamps()
  end

  @doc false
  def changeset(quiz_user, attrs) do
    quiz_user
    |> cast(attrs, [:is_player, :is_viewer, :user_id, :game_id])
    |> validate_required([:is_player, :is_viewer, :user_id, :game_id])
  end
end
