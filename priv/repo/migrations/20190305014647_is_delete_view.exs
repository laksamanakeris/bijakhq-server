defmodule Bijakhq.Repo.Migrations.IsDeleteView do
  use Ecto.Migration

  @up "CREATE VIEW view_users AS select 
      id, 
      inserted_at,
      updated_at,
      email,
      username,
      phone,
      profile_picture,
      confirmed_at,
      reset_sent_at,
      role,
      is_tester,
      country,
      language,
      games_played,
      has_phone,
      high_score,
      lives,
      referral_url,
      referred,
      win_count,
      verification_id,
      rank_weekly,
      rank_alltime,
      paypal_email,
      referring_user_id
      from users where deleted_at is null;"
  @down "DROP VIEW IF EXISTS view_users;"

  def change do
    execute(@up, @down)
  end
end
