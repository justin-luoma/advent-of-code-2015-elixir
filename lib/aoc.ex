defmodule AOC do
  @moduledoc """
  Documentation for `AOC`.
  """

  def main(_args) do
    rt = AOC.Day22.Part1.solve()
    IO.puts(rt)
  end

  def n_combo(0, _list), do: [[]]

  def n_combo(_, []), do: []

  def n_combo(n, [h|t]) do
    list = for l <- n_combo(n - 1, t), do: [h|l]

    list ++ n_combo(n, t)
  end
end
