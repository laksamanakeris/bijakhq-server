defmodule Bijakhq.Accounts.AliveUser do
  use Ecto.Schema
  alias Bijakhq.Accounts.AliveUser
  alias Bijakhq.Quizzes.QuizScore

  schema "alive_users" do
    field :username, :string
    field :email, :string
    field :phone, :string
    field :profile_picture, Bijakhq.ImageFile.Type
    field :confirmed_at, :utc_datetime
    field :reset_sent_at, :utc_datetime
    field :role, :string, default: "user" # user or admin
    field :is_tester, :boolean, default: false 
    field :country, :string, default: "MY"
    field :language, :string, default: "en"
    field :games_played, :integer, default: 0
    field :has_phone, :boolean, default: false
    field :high_score, :integer, default: 0
    field :lives, :integer, default: 0
    field :referral_url, :string
    field :referred, :boolean, default: false
    field :win_count, :integer, default: 0
    field :verification_id, :string
    field :rank_weekly, :integer
    field :rank_alltime, :integer
    field :paypal_email, :string
    timestamps()

    has_many :scores, QuizScore, foreign_key: :user_id
    belongs_to :referrer, AliveUser, foreign_key: :referring_user_id
  end
end
