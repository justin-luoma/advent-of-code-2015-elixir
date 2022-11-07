defmodule AOC.Day12.Part2 do

  def run() do
    "input/day12"
    |> File.read!()
    |> String.trim()
    |> parse()
    # |> (fn s -> Regex.scan(@digits, s, capture: :first) end).()
    # |> List.flatten()
    # |> Enum.map(&Integer.parse/1)
    # |> Enum.map(&elem(&1, 0))
    # |> Enum.sum()
  end

  def parse(str) do
    str
    |> Jason.decode()
    |> elem(1)
    |> evaluate([])
  end

  def evaluate([], nums), do: nums

  def evaluate([term | rest], nums) when is_integer(term), do: evaluate(rest, [term | nums])

  def evaluate([term | rest], nums) when is_list(term), do: evaluate(term ++ rest, nums)

  def evaluate([term | rest], nums) when is_map(term), do: evaluate(term, []) ++ evaluate(rest, nums)

  def evaluate([term | rest], nums) when is_binary(term) do
    case Integer.parse(term) do
      {i, _} ->
        evaluate(rest, [i | nums])

      :error ->
        evaluate(rest, nums)
    end
  end

  def evaluate(term, _) when is_map(term) do
    values = term
    |> Map.values()

    if Enum.member?(values, "red") do
      []
    else
      values
      |> evaluate([])
    end
  end
end
