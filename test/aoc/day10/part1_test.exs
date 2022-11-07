defmodule AOC.Day10.Part1Test do
	use ExUnit.Case, async: true
	alias AOC.Day10.Part1

  test "morph(n, 1)" do
    assert Integer.undigits(Part1.morph(1, 1)) == 11
    assert Integer.undigits(Part1.morph(11, 1)) == 21
    assert Integer.undigits(Part1.morph(21, 1)) == 1211
    assert Integer.undigits(Part1.morph(1211, 1)) == 111221
    assert Integer.undigits(Part1.morph(111221, 1)) == 312211
  end

  test "example" do
    assert Integer.undigits(Part1.morph(1, 5)) == 312211
  end

  @tag :skip
  test "puzzle" do
    assert Part1.morph(1113222113, 40) == 0
  end
end
