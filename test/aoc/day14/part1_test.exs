defmodule AOC.Day14.Part1Test do
	use ExUnit.Case, async: true
	alias AOC.Day14.Part1

  test "advance" do
    assert Part1.advance([{"Comet", 14, 10, 127}], 1, []) == [{"Comet", :flying, 14}]

    assert Part1.advance([{"Comet", 14, 10, 127}], 1000, []) == [{"Comet", :resting, 1120}]
    assert Part1.advance([{"Dancer", 16, 11, 162}], 1000, []) == [{"Dancer", :resting, 1056}]
  end
end
