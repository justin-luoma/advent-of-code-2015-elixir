defmodule AOC.Day12.Part1 do
  @digits ~r/(-?\d+)/

  def run() do
    "input/day12"
    |> File.read!()
    |> String.trim()
    |> (fn s -> Regex.scan(@digits, s, capture: :first) end).()
    |> List.flatten()
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum()
  end
end
