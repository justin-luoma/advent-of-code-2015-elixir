defmodule AOC.Day25.Part1 do
  @start 20_151_125

  def make_grid(max) do
    _make_grid({2, 1}, 2, @start, max, %{{1, 1} => @start})
  end

  defp _make_grid({x, y}, _xs, prev, _max, _grid) when x == 3010 and y == 3019,
    do: {prev, next(prev)}

  # defp _make_grid({x, _y}, _xs, _prev, max, grid) when x > max, do: grid

  defp _make_grid({x, y} = xy, xs, prev, max, grid) when y <= xs do
    next = next(prev)

    _make_grid({x - 1, y + 1}, xs, next, max, Map.put_new(grid, xy, next))
  end

  defp _make_grid(_, xs, prev, max, grid) do
    _make_grid({xs + 1, 1}, xs + 1, prev, max, grid)
  end

  def next(prev) do
    # prev + 1
    rem(prev * 252_533, 33_554_393)
  end

  def print_grid(grid, max) do
    data =
      for x <- 1..max do
        for y <- 1..max do
          Map.get(grid, {x, y})
        end
      end

    Scribe.print(data, [])
    # for x <- 1..max, y <- 1..max do
    #   if y == max do
    #     IO.write("#{Map.get(grid, {x, y})}\n")
    #   else
    #     IO.write("#{Map.get(grid, {x, y})}\t\t")
    #   end
    # end
  end
end
