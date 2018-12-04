defmodule Bijakhq.Quizzes.QuizUser do
  use Ecto.Schema
  import Ecto.Changeset


  schema "quiz_game_users" do
    field :is_player, :boolean, default: false
    field :is_viewer, :boolean, default: false
    field :session_id, :id
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(quiz_user, attrs) do
    quiz_user
    |> cast(attrs, [:is_player, :is_viewer])
    |> validate_required([:is_player, :is_viewer])
  end
end
