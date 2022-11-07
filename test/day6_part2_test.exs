defmodule Day6Part2Test do
  use ExUnit.Case, async: true
  alias AOC.Day6Part2

  setup_all do
    for(x <- 0..999, y <- 0..999, do: {x, y}) |> Map.from_keys(0)
  end

  test "update_grid :on", new_grid do
    grid = %{new_grid | {0, 0} => 1}
    assert Day6Part2.update_grid({:on, {0..0, 0..0}}, new_grid) == grid
  end

  test "update_grid :off" do
    assert Day6Part2.update_grid({:off, {0..0, 0..1}}, %{
             {0, 0} => 1,
             {0, 1} => 0
           }) == %{
             {0, 0} => 0,
             {0, 1} => 0
           }
  end

  test "update_grid :toggle", new_grid do
    grid = %{new_grid | {0, 0} => 2}
    assert Day6Part2.update_grid({:toggle, {0..0, 0..0}}, new_grid) == grid
  end

  @tag :skip
  test "puzzle" do
    assert Day6Part2.run() == 15343601
  end
end
