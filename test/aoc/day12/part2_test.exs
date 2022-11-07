defmodule AOC.Day12.Part2Test do
  use ExUnit.Case, async: true
  alias AOC.Day12.Part2

  test "evaluate" do
    assert Part2.evaluate(["1", "1"], []) == [1, 1]
    assert Part2.evaluate([1, "1"], []) == [1, 1]
    assert Part2.evaluate(%{"a" => 1, "b" => "1"}, []) == [1, 1]

    assert Part2.evaluate(%{"a" => %{"a" => "red", "b" => 1}, "b" => ["1", %{"a" => 1}]}, []) == [
             1,
             1
           ]

    assert Part2.evaluate(%{"a" => "red", "b" => "1"}, []) == []
    assert Part2.evaluate(%{"a" => [1, "red", "2"], "b" => %{:a => 1}}, []) == [1, 2, 1]
    assert Part2.evaluate(%{"a" => "red", "b" => "1", "c" => [1, 1, 2]}, []) == []
  end

  test "parse" do
    val =
      """
      [{"a": "1"}, {"a": "red", "b": 1}]
      """
      |> Part2.parse()

    assert val == [1]
  end
end
