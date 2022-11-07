defmodule AOC.Day17.Part1Test do
	use ExUnit.Case
	alias AOC.Day17.Part1

  test "t" do
    assert Part1.t(10, 15, [15], []) == {15, [25, 25]}
    assert Part1.t(10, 15, [20], []) == {15, [25, 20]}
    assert Part1.t(10, 10, [20, 10], []) == {10, [20, 20, 20]}
  end
end
