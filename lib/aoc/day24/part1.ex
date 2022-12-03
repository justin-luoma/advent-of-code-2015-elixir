defmodule AOC.Day24.Part1 do
  def solve() do
    list =
      "input/day24"
      |> File.read!()
      |> String.split("\r\n", trim: true)
      |> Enum.map(&Integer.parse/1)
      |> Enum.map(&elem(&1, 0))

    list
    |> (fn l -> AOC.n_combo(6, l) end).()
    |> Enum.filter(&(Enum.sum(&1) == 520))
    |> Enum.map(&Enum.sort/1)
    |> Enum.uniq()
    |> Enum.map(fn group1 ->
      {group1, make_groups(group1, list)}
    end)
    |> Enum.min_by(fn {group1, _} ->
      if length(group1) == 6 do
        Enum.product(group1)
      else
        999_999_999_999_999_999_999_999
      end
    end)
    |> elem(0)
    |> Enum.product()
  end

  def make_groups(group1, list) do
    (list -- group1)
    |> find_combo(6, 12)
    |> Enum.filter(fn group2 ->
      ((list -- group1) -- group2)
      |> Enum.sum() == 520
    end)
  end

  def find_combo(_list, n, max) when n > max, do: :none

  def find_combo(list, n, max) do
    combos =
      AOC.n_combo(n, list)
      |> Enum.filter(&(Enum.sum(&1) == 520))
      |> Enum.map(&Enum.sort/1)
      |> Enum.uniq()

    case combos do
      [] ->
        find_combo(list, n + 1, max)

      list ->
        list
    end
  end

  def pack(l) do
    max = Enum.sum(l) / 3
    containers = [1, 2, 3] |> Map.from_keys({0, []})

    l1 = [1, 89, 101, 107, 109, 113]

    containers = %{containers | 1 => {520, l1}}

    (l -- l1)
    |> Enum.sort(:desc)
    |> _pack(containers, max)
  end

  defp _pack([], containers, _), do: containers

  defp _pack([h | t], containers, max) do
    _pack(t, package(h, containers, max, 1), max)
  end

  def package(_, containers, _, container) when container > 3, do: containers

  def package(value, containers, max, container) do
    {weight, values} = containers[container]

    if weight < max && value + weight <= max do
      %{containers | container => {weight + value, [value | values]}}
    else
      package(value, containers, max, container + 1)
    end
  end
end
