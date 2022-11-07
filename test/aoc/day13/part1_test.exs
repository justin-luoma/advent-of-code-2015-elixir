defmodule AOC.Day13.Part1Test do
  use ExUnit.Case, async: true
  alias AOC.Day13.Part1

  @example """
  Alice would gain 54 happiness units by sitting next to Bob.
  Alice would lose 79 happiness units by sitting next to Carol.
  Alice would lose 2 happiness units by sitting next to David.
  Bob would gain 83 happiness units by sitting next to Alice.
  Bob would lose 7 happiness units by sitting next to Carol.
  Bob would lose 63 happiness units by sitting next to David.
  Carol would lose 62 happiness units by sitting next to Alice.
  Carol would gain 60 happiness units by sitting next to Bob.
  Carol would gain 55 happiness units by sitting next to David.
  David would gain 46 happiness units by sitting next to Alice.
  David would lose 7 happiness units by sitting next to Bob.
  David would gain 41 happiness units by sitting next to Carol.
  """

  setup_all do
    [
      values:
        @example
        |> String.split(".\r\n", trim: true)
        |> Enum.map(&String.split/1)
    ]
  end

  test "parse", state do
    assert Part1.parse(Enum.at(state[:values], 0)) == {"Alice", "Bob", 54}
    assert Part1.parse(Enum.at(state[:values], 1)) == {"Alice", "Carol", -79}
  end

  # @tag :skip
  test "transform", state do
    graph =
      state[:values]
      |> Enum.map(&Part1.parse/1)
      |> Part1.transform()

    assert Graph.neighbors(graph, "Alice") == ["David", "Bob", "Carol"]
  end

  test "neighbors" do
    assert Part1.neighbors(["David", "Bob", "Carol"]) == [
             ["Bob", "David"],
             ["Carol", "David"],
             ["Bob", "Carol"]
           ]
  end

  test "puzzle" do
    assert Part1.run() == 709
  end
end
