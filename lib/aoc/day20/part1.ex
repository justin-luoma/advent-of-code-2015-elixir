defmodule AOC.Day20.Part1 do
  import Integer, only: [is_even: 1, is_odd: 1]

  @multiplier 10

  @puzzle_input 34000000

  @presents_at_puzzle 896472900

  def solve() do
    self = self()
    Stream.chunk_every(1..@puzzle_input, 20000)
    |> Enum.map(fn list ->
      Task.async(fn ->
        filtered = list
        |> Enum.with_index()
        |> Enum.filter(fn {house, _i} -> AOC.Day20.Part1.presents(house) >= 896472900 end)

        if not Enum.empty?(filtered) do
          send(self, filtered)
        end
        filtered
      end)
    end)
    |> Enum.map(&Task.await(&1, :infinity))
    |> Enum.min_by(fn {_house, i} -> i end)
  end

  def testing() do
    Stream.chunk_every(1..100, 20)
    |> Enum.map(fn list ->
      self = self()
      Task.async(fn ->
        filtered = list
        |> Stream.with_index()
        |> Enum.filter(fn {e, _i} -> rem(e, 2) == 0 end)

        if not Enum.empty?(filtered) do
          send(self, filtered)
        end
        filtered
       end)
    end)
    |> Enum.map(&Task.await/1)
  end

  def house() do
    _house(1, @puzzle_input, @puzzle_input, presents(1))
  end

  def example() do
    _house(1, 10, 120, presents(1))
  end

  defp _house(i, max, _goal, _presents) when i > max, do: nil

  defp _house(i, _max, goal, presents) when presents >= goal, do: i

  defp _house(i, max, goal, _presents), do: _house(i + 1, max, goal, presents(i + 1))

  def presents(n), do: _presents(n, n, 0)

  defp _presents(_n, 0, total), do: total

  defp _presents(n, i, total) when n == i do
    _presents(n, i - 1, n * @multiplier + total)
  end

  defp _presents(n, i, total) when is_odd(n) and is_even(i),
    do: _presents(n, i - 1, total)

  defp _presents(n, i, total) when rem(n, i) == 0 do
    _presents(n, i - 1, i * @multiplier + total)
  end

  defp _presents(n, i, total), do: _presents(n, i - 1, total)
end
