defmodule Day3Test do
  use ExUnit.Case, async: true

  test "base" do
    assert AOC.Day3.solve("") == 1
  end

  test "east" do
    assert AOC.Day3.solve(">") == 2
  end

  test "west" do
    assert AOC.Day3.solve("<") == 2
  end

  test "south" do
    assert AOC.Day3.solve("v") == 2
  end

  test "north" do
    assert AOC.Day3.solve("^") == 2
  end

  test "example 1" do
    assert AOC.Day3.solve("^>v<") == 4
  end

  test "example 2" do
    assert AOC.Day3.solve("^v^v^v^v^v") == 2
  end

  test "puzzle" do
    assert AOC.Day3.run() == 2572
  end

  test "p2 base" do
    assert AOC.Day3.solve_p2("") == 1
  end

  test "p2 east" do
    assert AOC.Day3.solve_p2(">") == 2
  end

  test "p2 example 1" do
    assert AOC.Day3.solve_p2("^v") == 3
  end

  test "p2 example 2" do
    assert AOC.Day3.solve_p2("^>v<") == 3
  end

  test "p2 example 3" do
    assert AOC.Day3.solve_p2("^v^v^v^v^v") == 11
  end

  test "puzzle p2" do
    assert AOC.Day3.run_p2() == 2631
  end
end
