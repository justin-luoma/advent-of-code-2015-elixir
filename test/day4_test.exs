defmodule Day4Test do
  use ExUnit.Case, async: true

  @tag :skip
  test "example 1" do
    assert AOC.Day4.solve_p1("abcdef") == 609043
  end

  @tag :skip
  test "example 2" do
    assert AOC.Day4.solve_p1("pqrstuv") == 1048970
  end

  @tag :skip
  test "puzzle" do
    assert AOC.Day4.solve_p1("yzbqklnj") == 282749
  end

  @tag :skip
  test "puzzle p2" do
    assert AOC.Day4.solve_p2("yzbqklnj", 1) == 9962624
  end
end
