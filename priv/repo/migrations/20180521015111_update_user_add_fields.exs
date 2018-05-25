defmodule Bijakhq.Repo.Migrations.UpdateUserAddFields do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :country, :string, default: "MY"
      add :language, :string, default: "en"

      add :games_played, :integer, default: 0
      add :has_phone, :boolean, default: false
      add :high_score, :integer, default: 0
      add :lives, :integer, default: 0
      add :referral_url, :string
      add :referred, :boolean, default: false
      add :referring_user_id, :integer
      add :win_count, :integer, default: 0
      add :verification_id, :string
    end

  end
end
