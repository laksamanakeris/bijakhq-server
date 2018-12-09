defmodule Bijakhq.Game.Player do

  require Logger

  alias Bijakhq.Game.Player
  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.User

  defstruct [:id, 
    :lives, 
    :high_score, 
    :role, 
    :username, 
    :win_count, 
    :profile_picture,
    is_playing: false,
    eliminated: false,
    extra_lives_remaining: 0,
    saved_by_extra_life: false,
    is_winner: false,
    answers: %{}
  ]

  def new(user) do
    player = %Bijakhq.Game.Player{
      id: user.id, 
      lives: user.lives, 
      high_score: user.high_score, 
      role: user.role, 
      username: user.username, 
      win_count: user.win_count, 
      profile_picture: user.profile_picture,
      is_playing: user.is_playing,
      eliminated: user.eliminated,
      extra_lives_remaining: extra_life(user.lives)
    }

  end

  def update_answer(player, question_id, answer_id) do
    answers = player.answers
    answers = Map.put(answers, question_id, answer_id)
    %{player | answers: answers}
  end

  def get_answer(player, question_id) do
    player.answers[question_id]
  end

  def process_answer(player, user_answer, question) do
    selected_answer = Enum.find(question.answers, fn u -> u.id == user_answer end)
    if selected_answer.answer == false do
      player_have_wrong_answer(player)
    else
      player
    end
  end

  def player_have_wrong_answer(player) do
    player = 
      if player.extra_lives_remaining > 0 do
        Map.merge(player, %{extra_lives_remaining: 0,saved_by_extra_life: true})
      else
        Map.merge(player, %{extra_lives_remaining: 0,eliminated: true})
      end
  end

  def player_minus_life(player) do
    with user <- Accounts.get(player.id) do
      Accounts.update_user(user, %{lives: user.lives - 1})
    end
  end

  # utils
  defp extra_life(lives) do
    cond do
      lives > 0 -> 1
      true -> 0
    end
  end

end