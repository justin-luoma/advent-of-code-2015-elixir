defmodule AOC.Day18.Part2 do
  @grid 100
  @steps 100

  def solve() do
    "input/day18"
    |> parse()
    |> iterate(@steps)
    |> Map.values()
    |> Enum.reduce(0, fn e, acc -> if e, do: acc + 1, else: acc end)
  end

  def iterate(grid, n) do
    _iterate(grid, 0, n)
  end

  defp _iterate(grid, i, loop) when i == loop, do: grid

  defp _iterate(grid, i, loop) do
    _iterate(part2(next(grid, @grid)), i + 1, loop)
  end

  def parse(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, "", trim: true))
    # |> IO.inspect(label: :split)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {states, y}, grid ->
      states
      |> Enum.with_index()
      |> Enum.reduce(grid, fn
        {".", x}, grid ->
          Map.put_new(grid, {x + 1, y + 1}, false)

        {"#", x}, grid ->
          Map.put_new(grid, {x + 1, y + 1}, true)
      end)
    end)
    |> part2()
  end

  def part2(grid) do
    %{grid | {1, 1} => true, {@grid, 1} => true, {1, @grid} => true, {@grid, @grid} => true}
  end

  def print_grid(grid, n) do
    Map.keys(grid)
    |> Enum.sort_by(fn {x, y} -> {y, x} end)
    # |> IO.inspect(label: :keys)
    |> Enum.map(fn key -> Map.get(grid, key) end)
    |> Enum.chunk_every(n)
  end

  def next(grid, n), do: Map.keys(grid) |> _next(grid, n, grid)

  defp _next([], _grid, _n, acc), do: acc

  defp _next([h | t], grid, n, acc) do
    neighbors =
      neighbors(h, n)
      |> Enum.map(fn key -> Map.get(grid, key) end)
      |> Enum.reduce(0, fn
        true, acc -> acc + 1
        false, acc -> acc
      end)

    if not Map.get(grid, h) && neighbors == 3 do
      _next(t, grid, n, %{acc | h => true})
    else
      if neighbors != 2 && neighbors != 3 do
        _next(t, grid, n, %{acc | h => false})
      else
        _next(t, grid, n, acc)
      end
    end
  end

  def neighbors({x, y}, _n) when x == 1 and y == 1 do
    [{x + 1, y}, {x, y + 1}, {x + 1, y + 1}]
  end

  def neighbors({x, y}, n) when x == 1 and y == n do
    [{x, y - 1}, {x + 1, y}, {x + 1, y - 1}]
  end

  def neighbors({x, y}, n) when x == n and y == 1 do
    [{x - 1, y}, {x, y + 1}, {x - 1, y + 1}]
  end

  def neighbors({x, y}, n) when x == n and y == n do
    [{x - 1, y - 1}, {x, y - 1}, {x - 1, y}]
  end

  # left edge
  def neighbors({x, y}, _n) when x == 1 do
    [{x, y - 1}, {x, y + 1}, {x + 1, y}, {x + 1, y - 1}, {x + 1, y + 1}]
  end

  def neighbors({x, y}, _n) when y == 1 do
    [{x, y + 1}, {x + 1, y + 1}, {x + 1, y}, {x - 1, y + 1}, {x - 1, y}]
  end

  def neighbors({x, y}, n) when x == n do
    [{x, y - 1}, {x, y + 1}, {x - 1, y}, {x - 1, y - 1}, {x - 1, y + 1}]
  end

  def neighbors({x, y}, n) when y == n do
    [{x - 1, y}, {x + 1, y}, {x, y - 1}, {x + 1, y - 1}, {x - 1, y - 1}]
  end

  def neighbors({x, y}, _n) do
    [
      {x, y + 1},
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x - 1, y - 1},
      {x - 1, y + 1},
      {x + 1, y - 1},
      {x + 1, y + 1}
    ]
  end

  def create_list(grid, n) do
    for i <- 1..n do
      _create_list(grid, 1, i, n, [])
    end
  end

  def _create_list(_grid, i, _y, n, acc) when i > n, do: acc

  def _create_list(grid, i, y, n, acc) do
    _create_list(
      grid,
      i + 1,
      y,
      n,
      [Map.get(grid, {i, y}) | acc]
    )
  end

  def make_grid(state) do
    state
  end
end
