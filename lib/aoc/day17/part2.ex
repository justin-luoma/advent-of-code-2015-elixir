defmodule AOC.Day17.Part2 do
  def find_min(l) do
    l
    |> Enum.min_by(&length/1)
    |> length()
  end

  def solve() do
    list = AOC.Day17.Part1.solve_part1()

    min = find_min(list)

    list
    |> Enum.filter(fn l -> length(l) == min end)
  end
end
