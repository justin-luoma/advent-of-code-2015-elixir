defmodule AOC.Day16.Part1 do
  @clue %{
    "children" => 3,
    "cats" => 7,
    "samoyeds" => 2,
    "pomeranians" => 3,
    "akitas" => 0,
    "vizslas" => 0,
    "goldfish" => 5,
    "trees" => 3,
    "cars" => 2,
    "perfumes" => 1
  }

  def run() do
    "input/day16"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ~r/[: ,]+/))
    |> Enum.map(&parse/1)
    # Part 1
    # |> Enum.filter(fn {_, {k1, v1}, {k2, v2}, {k3, v3}} ->
    #   @clue[k1] == v1 && @clue[k2] == v2 && @clue[k3] == v3
    # end)
    # Part 2
    |> Enum.filter(&filter/1)

    # |> Enum.reduce(%{}, fn {n, v1, v2, v3}, map ->
    #   Map.put_new(map, n, {v1, v2, v3})
    # end)
  end

  def filter({_, a, b, c}), do: _filter(a) && _filter(b) && _filter(c)

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k1 in ["cats", "trees"] do
  #   @clue[k1] > v1 && @clue[k2] == v2 && @clue[k3] == v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k2 in ["cats", "trees"] do
  #   @clue[k1] == v1 && @clue[k2] > v2 && @clue[k3] == v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k3 in ["cats", "trees"] do
  #   @clue[k1] == v1 && @clue[k2] == v2 && @clue[k3] > v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k1 in ["pomeranians", "goldfish"] do
  #   @clue[k1] < v1 && @clue[k2] == v2 && @clue[k3] == v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k2 in ["pomeranians", "goldfish"] do
  #   @clue[k1] == v1 && @clue[k2] < v2 && @clue[k3] == v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) when k3 in ["pomeranians", "goldfish"] do
  #   @clue[k1] == v1 && @clue[k2] == v2 && @clue[k3] < v3
  # end

  # def filter({_, {k1, v1}, {k2, v2}, {k3, v3}}) do
  #   @clue[k1] == v1 && @clue[k2] == v2 && @clue[k3] == v3
  # end

  defp _filter({k, v}) when k in ["cats", "trees"] do
    @clue[k] < v
  end

  defp _filter({k, v}) when k in ["pomeranians", "goldfish"] do
    @clue[k] > v
  end

  defp _filter({k, v}) do
    @clue[k] == v
  end

  def parse([_, n, i1, v1, i2, v2, i3, v3]) do
    {n, {i1, p(v1)}, {i2, p(v2)}, {i3, p(v3)}}
  end

  defp p(s) do
    s |> Integer.parse() |> elem(0)
  end
end
