defmodule AOC.Day1 do
  def solve_p1(directions) do
    String.graphemes(directions)
    |> _solve_p1(0)
  end

  defp _solve_p1([], floor), do: floor
  defp _solve_p1(["(" | tail], floor), do: _solve_p1(tail, floor + 1)
  defp _solve_p1([")" | tail], floor), do: _solve_p1(tail, floor - 1)


  def solve_p2(puzzle) do
    puzzle
    |> String.graphemes()
    |> _solve_p2(0, 0)
  end

  defp _solve_p2(_, floor, pos) when floor == -1, do: pos
  defp _solve_p2(["(" | tail], floor, pos), do: _solve_p2(tail, floor + 1, pos + 1)
  defp _solve_p2([")" | tail], floor, pos), do: _solve_p2(tail, floor - 1, pos + 1)
end
