defmodule Bijakhq.Game.Questions do

  def create_question_list(game_questions) do
    #IO.inspect game_questions
  end

  def increment_question_answer(game_state, question_id, answer_id) do
    # #IO.inspect game
      #IO.puts "=============================================================================="
      questions = game_state.questions
      question = Enum.at( questions , question_id)
      question = Map.put(question, :question_id, question_id)

      old_value = question.answers_sequence.answers

      # #IO.inspect old_value
      #IO.puts "=============================================================================="
      new_value = Enum.map(old_value, fn(subj) ->
        %{id: id} = subj
        if id == answer_id do
          %{subj | total_answered: subj.total_answered + 1}
        else
          subj
        end
      end)

      # #IO.inspect new_value
      #IO.puts "=============================================================================="

      # update question
      answers_sequence = %{question.answers_sequence | answers: new_value}
      question = %{question | answers_sequence: answers_sequence}

      # update questions list
      old_question_list = questions

      new_question_list = Enum.map(old_question_list, fn(subj) ->
        %{id: id} = subj
        if id == question.id do
          question
        else
          subj
        end
      end)

      %{game_state | questions: new_question_list}
  end

  def get_question_by_id(game_state, question_id) do
    # #IO.inspect game_state
    questions = game_state.questions
    question = Enum.at(questions,question_id)
    question.answers_sequence
  end
end
