defmodule AOC.Day13.Part2Test do
	use ExUnit.Case, async: true
	alias AOC.Day13.Part2

  test "puzzle" do
    assert Part2.run() == 668
  end
end
