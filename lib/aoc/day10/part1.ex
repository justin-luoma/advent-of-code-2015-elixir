defmodule AOC.Day10.Part1 do
  def morph(input, i), do: _morph(Integer.digits(input), 1, [], 1, i)

  defp _morph([d | []], say, seq, i, loop) when i == loop, do: concat(seq, say, d)

  defp _morph([d | []], say, seq, i, loop), do: _morph(List.flatten([seq, say, d]), 1, [], i + 1, loop)

  defp _morph([d | rest], say, seq, i, loop) when hd(rest) == d do
    _morph(rest, say + 1, seq, i, loop)
  end

  defp _morph([d | rest], say, seq, i, loop) do
    _morph(rest, 1, seq ++ [say, d], i, loop)
  end

  defp concat(seq, say, d), do: [seq, say, d]
  |> List.flatten()

  def run(), do: morph(1113222113, 40)
end
