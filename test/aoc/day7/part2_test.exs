defmodule AOC.Day7.Part2Test do
	use ExUnit.Case, async: true
	alias AOC.Day7.Part2

  test "parse :set" do
    assert "123 -> x" |> String.split() |> Part2.parse() == {"x", 123}
    assert "y -> x" |> String.split() |> Part2.parse() == {"x", {:wire, "y"}}
  end

  test "parse :and" do
    assert "x AND y -> d" |> String.split() |> Part2.parse() == {"d", {:and, "x", "y"}}
    assert "1 AND y -> d" |> String.split() |> Part2.parse() == {"d", {:and, 1, "y"}}
  end

  test "parse :or" do
    assert "x OR y -> d" |> String.split() |> Part2.parse() == {"d", {:or, "x", "y"}}
  end

  test "parse :lshift" do
    assert "x LSHIFT 2 -> f" |> String.split() |> Part2.parse() == {"f", {:lshift, "x", 2}}
  end

  test "parse :rshift" do
    assert "x RSHIFT 2 -> f" |> String.split() |> Part2.parse() == {"f", {:rshift, "x", 2}}
  end

  test "parse :not" do
    assert "NOT x -> h" |> String.split() |> Part2.parse() == {"h", {:not, "x"}}
  end

  test "read_wire signal base case" do
    assert 123 |> Part2.read_wire(%{}) == 123
  end

  test "read_wire wires" do
    assert {:wire, "x"} |> Part2.read_wire(%{"x" => 123}) == 123
    assert {:wire, "x"} |> Part2.read_wire(%{"x" => {:wire, "y"}, "y" => 123}) == 123
  end

  test "read_wire ands" do
    assert {:and, 123, "x"} |> Part2.read_wire(%{"x" => 456}) == 72
    assert {:and, 123, "x"} |> Part2.read_wire(%{"x" => {:wire, "y"}, "y" => 456}) == 72
    assert {:and, "x", "y"} |> Part2.read_wire(%{"x" => 123, "y" => 456}) == 72
  end

  test "read_wire not" do
    assert {:not, "x"} |> Part2.read_wire(%{"x" => 456}) == 65079
  end

  @tag :skip
  test "puzzle" do
    assert Part2.parse_instructions() == 0
  end
end
