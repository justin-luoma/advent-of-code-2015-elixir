defmodule AOC.Day6Part2 do
  def run() do
    keys = for x <- 0..999, y <- 0..999, do: {x, y}
    grid = Map.from_keys(keys, 0)

    "input/day6"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse_input/1)
    |> Enum.reduce(grid, fn i, grid -> update_grid(i, grid) end)
    |> Map.values()
    |> Enum.sum()
  end

  def update_grid({:on, {x, y}}, grid) do
    keys = for x <- x, y <- y, do: {x, y}

    Map.from_keys(keys, 1)
    |> Map.merge(grid, fn _, v1, v2 -> v1 + v2 end)
  end

  def update_grid({:off, {x, y}}, grid) do
    coords = for x <- x, y <- y, do: {x, y}
    turn_off(coords, grid)
  end

  def update_grid({:toggle, {x, y}}, grid) do
    coords = for x <- x, y <- y, do: {x, y}
    toggle(coords, grid)
  end

  defp turn_off([], grid), do: grid

  defp turn_off([coords | rest], grid),
    do: turn_off(rest, elem(Map.get_and_update(grid, coords, &{&1, max(&1 - 1, 0)}), 1))

  defp toggle([], grid), do: grid

  defp toggle([coords | rest], grid) do
    toggle(rest, Map.get_and_update(grid, coords, &({&1, &1 + 2})) |> elem(1))
    # if Map.has_key?(grid, coords) do
    #   toggle(rest, Map.delete(grid, coords))
    # else
    #   toggle(rest, Map.put_new(grid, coords, true))
    # end
  end

  def parse_input(["turn", "on", start, _, stop]) do
    {x, y} = parse_coords(start)
    {x2, y2} = parse_coords(stop)
    {:on, {x..x2, y..y2}}
  end

  def parse_input(["turn", "off", start, _, stop]) do
    {x, y} = parse_coords(start)
    {x2, y2} = parse_coords(stop)
    {:off, {x..x2, y..y2}}
  end

  def parse_input(["toggle", start, _, stop]) do
    {x, y} = parse_coords(start)
    {x2, y2} = parse_coords(stop)
    {:toggle, {x..x2, y..y2}}
  end

  defp parse_coords(s) do
    s
    |> String.split(",")
    |> Enum.map(fn a ->
      Integer.parse(a)
      |> elem(0)
    end)
    |> List.to_tuple()
  end
end
