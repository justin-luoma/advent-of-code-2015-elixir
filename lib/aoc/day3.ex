defmodule AOC.Day3 do
  def solve(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> _solve({0, 0}, %{{0, 0} => 1})
  end

  defp _solve([], _, grid) do
    grid
    |> Map.to_list()
    |> Enum.filter(fn {_, b} -> b >= 1 end)
    |> Enum.count()
  end

  defp _solve([">" | rest], {x, y}, grid) do
    pos = {x + 1, y}
    new_grid = Map.update(grid, pos, 1, &(&1 + 1))
    _solve(rest, pos, new_grid)
  end

  defp _solve(["<" | rest], {x, y}, grid) do
    pos = {x - 1, y}
    new_grid = Map.update(grid, pos, 1, &(&1 + 1))
    _solve(rest, pos, new_grid)
  end

  defp _solve(["v" | rest], {x, y}, grid) do
    pos = {x, y + 1}
    new_grid = Map.update(grid, pos, 1, &(&1 + 1))
    _solve(rest, pos, new_grid)
  end

  defp _solve(["^" | rest], {x, y}, grid) do
    pos = {x, y - 1}
    new_grid = Map.update(grid, pos, 1, &(&1 + 1))
    _solve(rest, pos, new_grid)
  end

  def run() do
    File.read!("input/day3")
    |> String.trim()
    |> solve()
  end

  def run_p2() do
    File.read!("input/day3")
    |> String.trim()
    |> solve_p2()
  end

  def solve_p2(input) do
    input
    |> String.trim()
    |> String.graphemes()
    |> _p2({{0, 0}, {0, 0}}, %{{0,0} => 1}, %{{0,0} => 1}, true)
  end

  defp _p2([], _, santa, robo, _) do
    Map.merge(santa, robo, fn (_k, v1, v2) -> v1+v2 end)
    |> Map.to_list()
    |> Enum.filter(fn {_, b} -> b >= 1 end)
    |> Enum.count()
  end

  defp _p2([">" | rest], {{x1, y1}, {x2, y2}}, santa, robo, move_santa) do
    if move_santa do
      pos = {{x1 + 1, y1}, {x2, y2}}
      new_grid = Map.update(santa, elem(pos, 0), 1, &(&1 + 1))
      _p2(rest, pos, new_grid, robo, not move_santa)
    else
      pos = {{x1, y1}, {x2 + 1, y2}}
      new_grid = Map.update(robo, elem(pos, 1), 1, &(&1 + 1))
      _p2(rest, pos, santa, new_grid, not move_santa)
    end
  end

  defp _p2(["<" | rest], {{x1, y1}, {x2, y2}}, santa, robo, move_santa) do
    if move_santa do
      pos = {{x1 - 1, y1}, {x2, y2}}
      new_grid = Map.update(santa, elem(pos, 0), 1, &(&1 + 1))
      _p2(rest, pos, new_grid, robo, not move_santa)
    else
      pos = {{x1, y1}, {x2 - 1, y2}}
      new_grid = Map.update(robo, elem(pos, 1), 1, &(&1 + 1))
      _p2(rest, pos, santa, new_grid, not move_santa)
    end
  end

  defp _p2(["^" | rest], {{x1, y1}, {x2, y2}}, santa, robo, move_santa) do
    if move_santa do
      pos = {{x1, y1 - 1}, {x2, y2}}
      new_grid = Map.update(santa, elem(pos, 0), 1, &(&1 + 1))
      _p2(rest, pos, new_grid, robo, not move_santa)
    else
      pos = {{x1, y1}, {x2, y2 - 1}}
      new_grid = Map.update(robo, elem(pos, 1), 1, &(&1 + 1))
      _p2(rest, pos, santa, new_grid, not move_santa)
    end
  end

  defp _p2(["v" | rest], {{x1, y1}, {x2, y2}}, santa, robo, move_santa) do
    if move_santa do
      pos = {{x1, y1 + 1}, {x2, y2}}
      new_grid = Map.update(santa, elem(pos, 0), 1, &(&1 + 1))
      _p2(rest, pos, new_grid, robo, not move_santa)
    else
      pos = {{x1, y1}, {x2, y2 + 1}}
      new_grid = Map.update(robo, elem(pos, 1), 1, &(&1 + 1))
      _p2(rest, pos, santa, new_grid, not move_santa)
    end
  end
end
