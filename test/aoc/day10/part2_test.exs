defmodule AOC.Day10.Part2Test do
	use ExUnit.Case, async: true
	alias AOC.Day10.Part2

  test "morph" do
    assert Part2.morph(1113222113, 1) == [3, 1, 1, 3, 3, 2, 2, 1, 1, 3]
    assert Part2.morph(1113222113, 2) == [1, 3, 2, 1, 2, 3, 2, 2, 2, 1, 1, 3]


    assert Part2.test(1113222113, 1) == Part2.morph(1113222113, 1)
    assert Part2.test(1113222113, 2) == Part2.morph(1113222113, 2)
    assert Part2.test(1113222113, 3) == Part2.morph(1113222113, 3)
    assert Part2.test(1113222113, 10) == Part2.morph(1113222113, 10)
  end
end
