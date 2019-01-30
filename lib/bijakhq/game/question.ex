defmodule Bijakhq.Game.Question do

  @enforce_keys [:question, :answers, :description]
  defstruct [:question, :answers, :description]

  @doc """
  Creates a player with the given `name` and `color`.
  """
  def new(question, answers, description) do
    %Bijakhq.Game.Question{question: question, answers: answers, description: description}
  end
end
