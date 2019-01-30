defmodule Bijakhq.Game.Player do

  require Logger

  alias Bijakhq.Game.Player
  alias Bijakhq.Accounts
  alias Bijakhq.Accounts.User

  @ets_name :game_players

  defstruct [:id, 
    :lives, 
    :high_score, 
    :role, 
    :username,
    :email,
    :is_tester, 
    :win_count, 
    :profile_picture,
    is_playing: false,
    eliminated: false,
    extra_lives_remaining: 0,
    saved_by_extra_life: false,
    is_winner: false,
    amounts: 0,
    answers: %{}
  ]

  def new(user, is_playing \\ false, eliminated \\ true) do
    player = %Bijakhq.Game.Player{
      id: user.id, 
      lives: user.lives, 
      high_score: user.high_score, 
      role: user.role, 
      username: user.username,
      email: user.email, 
      is_tester: user.is_tester,
      win_count: user.win_count, 
      profile_picture: user.profile_picture,
      is_playing: is_playing,
      eliminated: eliminated,
      saved_by_extra_life: false,
      is_winner: false,
      amounts: 0,
      extra_lives_remaining: extra_life(user.lives, is_playing)
    }

  end

  def update_answer(player, question_id, answer_id) do
    answers = player.answers
    answers = Map.put(answers, question_id, %{answer_id: answer_id, ts: DateTime.utc_now})
    %{player | answers: answers}
  end

  def get_answer(player, question_id) do
    answer = player.answers[question_id]
    # IO.inspect answer
    # Logger.warn "============================== get_answer #{player.username} :: #{answer}"
    case answer do
      nil ->
        player = Player.update_answer(player, question_id, 4)
        :ets.insert(@ets_name, {player.id, player})
      _ ->
        %{answer_id: answer_id, ts: _} = answer
        answer_id
    end

  end

  def process_answer(player, user_answer, question, is_test_game, is_last_question) do
    # Logger.warn "============================== Process_answer #{player.username} :: #{user_answer}"
    selected_answer = Enum.find(question.answers, fn u -> u.id == user_answer end)
    # IO.inspect selected_answer
    case selected_answer do
      nil -> 
        # meaning user not answering the question
        player_have_wrong_answer(player, is_test_game, is_last_question)
      _ -> 
        if selected_answer.answer == false do
          player_have_wrong_answer(player, is_test_game, is_last_question)
        else
          player
        end
    end
  end

  def player_have_wrong_answer(player, is_test_game, is_last_question) do
    # Logger.warn "============================== Player_have_wrong_answer #{player.username} - is_last_question = #{is_last_question}"
    player = 
      if player.extra_lives_remaining > 0 && is_last_question == false do
        player = Map.merge(player, %{extra_lives_remaining: 0,saved_by_extra_life: true})
        :ets.insert(@ets_name, {player.id, player})
        if is_test_game == false do
          Task.start(Bijakhq.Game.Player, :player_minus_life, [player])
        end
      else
        player = Map.merge(player, %{extra_lives_remaining: 0,eliminated: true})
        :ets.insert(@ets_name, {player.id, player})
      end
  end

  def player_minus_life(player) do
    with user <- Accounts.get(player.id) do
      Accounts.update_user(user, %{lives: user.lives - 1})
    end
  end

  # utils
  defp extra_life(lives, is_playing) do
    count =
      cond do
        lives > 0 -> 1
        true -> 0
      end
    
    life =
      if is_playing == true do
        count
      else
        0
      end
    
    life
  end

end