defmodule AOC.Day15.Part1 do


  def run() do
    "input/day15"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ~r/[: ,]+/))
    |> Enum.map(&parse/1)
    |> process()
    |> Enum.max_by(fn
      [] -> 0
      e -> elem(e, 0) |> elem(4)
    end)
  end

  def process([
        {name1, capacity1, durability1, flavor1, texture1, _calories1},
        {name2, capacity2, durability2, flavor2, texture2, _calories2},
        {name3, capacity3, durability3, flavor3, texture3, _calories3},
        {name4, capacity4, durability4, flavor4, texture4, _calories4}
      ]) do
    for i <- 1..97, j <- 1..97, k <- 1..97, l <- 1..97, i + j + k + l == 100 do
      capacity = i * capacity1 + j * capacity2 + k * capacity3 + l * capacity4
      durability = i * durability1 + j * durability2 + k * durability3 + l * durability4
      flavor = i * flavor1 + j * flavor2 + k * flavor3 + l * flavor4
      texture = i * texture1 + j * texture2 + k * texture3 + l * texture4

      if capacity <= 0 || durability <= 0 || flavor <= 0 || texture <= 0 do
        []
      else
        score = capacity * durability * flavor * texture

        {
          {{name1, i}, {name2, j}, {name3, k}, {name4, l}, score},
          capacity,
          durability,
          flavor,
          texture
        }
      end
    end
  end

  def example() do
    "input/day15example"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, ~r/[: ,]+/))
    |> Enum.map(&parse/1)
    |> process_example()
    |> Enum.max_by(fn
      [] -> 0
      e -> elem(e, 0) |> elem(2)
    end)
  end

  def process_example([
        {name1, capacity1, durability1, flavor1, texture1, _calories1},
        {name2, capacity2, durability2, flavor2, texture2, _calories2}
      ]) do
    for i <- 1..97, j <- 1..97, i + j == 100 do
      capacity = i * capacity1 + j * capacity2
      durability = i * durability1 + j * durability2
      flavor = i * flavor1 + j * flavor2
      texture = i * texture1 + j * texture2

      if capacity <= 0 || durability <= 0 || flavor <= 0 || texture <= 0 do
        []
      else
        score = capacity * durability * flavor * texture

        {
          {{name1, i}, {name2, j}, score},
          capacity,
          durability,
          flavor,
          texture
        }
      end
    end
  end

  def parse([name, _, cap, _, dur, _, flavor, _, texture, _, cal]) do
    {name, cap |> p(), dur |> p(), flavor |> p(), texture |> p(), cal |> p()}
  end

  defp p(s) do
    s |> Integer.parse() |> elem(0)
  end

  def combos() do
    for i <- 1..97, j <- 1..97, k <- 1..97, l <- 1..97, i + j + k + l == 100, do: {i, j, k, l}
  end
end
