defmodule AOC.Day14.Part2 do
  alias AOC.Day14.Part1

  def run() do
    rein =
      "input/day14"
      |> File.read!()
      |> String.split("\r\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(&Part1.parse/1)

    rein
    |> Enum.reduce(%{}, fn {name, _speed, _dur, _rest}, map ->
      Map.put_new(map, name, 0)
    end)
    |> tally(rein, 0, 2503)
  end

  def example() do
    rein =
      "input/day14example"
      |> File.read!()
      |> String.split("\r\n", trim: true)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(&Part1.parse/1)

    rein
    |> Enum.reduce(%{}, fn {name, _speed, _dur, _rest}, map ->
      Map.put_new(map, name, 0)
    end)
    |> tally(rein, 0, 1000)
  end

  def tally(state, _, i, sec) when i > sec, do: state

  def tally(state, rein, i, sec) do
    Part1.advance(rein, i + 1, [])
    |> update(state)
    |> tally(rein, i + 1, sec)
  end

  def update(rein, state) do
    rein
    |> Enum.sort_by(fn {_, _, dist} -> dist end, :desc)
    |> Enum.reduce({[], 0}, fn {_, _, dist} = e, {acc, max} ->
      cond do
        dist > max ->
          {[e | acc], dist}

        dist == max ->
          {[e | acc], max}

        true ->
          {acc, max}
      end
    end)
    |> elem(0)
    |> Enum.reduce(state, fn {key, _, _}, state ->
      Map.get_and_update!(state, key, fn old -> {old, old + 1} end) |> elem(1)
    end)

    # |> (fn {key, _, _} -> Map.get_and_update!(state, key, fn old -> {old, old + 1} end) |> elem(1) end).()
  end
end
