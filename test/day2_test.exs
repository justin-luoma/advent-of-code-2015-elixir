defmodule Day2Test do
  use ExUnit.Case, async: true

  test "example 1" do
    assert AOC.Day2.paper_needed({2, 3, 4}) == 58
  end

  test "example 2" do
    assert AOC.Day2.paper_needed({1, 1, 10}) == 43
  end

  test "ribbon 1" do
    assert AOC.Day2.ribbon_needed({2, 3, 4}) == 34
  end

  test "ribbon 2" do
    assert AOC.Day2.ribbon_needed({1, 1, 10}) == 14
  end
end
