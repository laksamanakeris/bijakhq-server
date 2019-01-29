defmodule Bijakhq.Utils.WordFilter do
  alias Poison.Parser, as: JSON

  defmacrop matches do
    blacklist = File.open!(Application.get_env(:bijakhq, :bad_words), [:read], fn(file) ->
      IO.read(file, :all)
    end)
    blacklist = JSON.parse!(blacklist)
    regex = blacklist |> Enum.join("|")
    quote do
      unquote(regex)
    end
  end

  def has_profanity?(nil), do: false
  def has_profanity?(string) when string |> is_binary do
    {:ok, regex} = Regex.compile(matches)
    Regex.match?(regex, string)
  end

end