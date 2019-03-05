defmodule Bijakhq.Repo.Migrations.IsDeleteViewQuizSession do
  use Ecto.Migration

  @up "CREATE VIEW alive_quiz_sessions AS select 
      id, 
      name,
      inserted_at,
      updated_at,
      completed_at,
      description,
      is_active,
      is_completed,
      is_hidden,
      prize,
      prize_description,
      time,
      total_questions,
      stream_url
      from quiz_sessions where not is_deleted;"
  @down "DROP VIEW IF EXISTS alive_quiz_sessions;"

  def change do
    execute(@up, @down)
  end
end
