defmodule AOC.Day20.Part2 do
  @puzzle 34_000_000
  @multiplier 11
  @max 50

  def house() do
    _house(2, %{})
  end

  defp _house(elf, map) when elf < @puzzle do
    map = elf(elf, map, @puzzle, @max)

    if Map.get(map, elf) >= @puzzle do
      {elf, Map.get(map, elf)}
    else
      _house(elf + 1, map)
    end
  end

  

  def elf(n, map, range, max) do
    Enum.take_every(n..range, n)
    |> Enum.take(max)
    |> Enum.reduce(map, fn house, map ->
      Map.get_and_update(map, house, fn
        nil ->
          {nil, 10 + n * @multiplier}

        val ->
          {val, val + n * @multiplier}
      end)
      |> elem(1)
    end)
  end
end
