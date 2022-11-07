defmodule AOC.Day14.Part2Test do
	use ExUnit.Case, async: true
	alias AOC.Day14.Part2

  test "update" do
    assert Part2.update([{"Comet", :flying, 10}], %{"Comet" => 0}) == %{"Comet" => 1}
  end
end
