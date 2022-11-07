defmodule AOC.Day7.Part1Test do
	use ExUnit.Case, async: true
	alias AOC.Day7.Part1

  test "parse :set" do
    assert "123 -> x" |> String.split() |> Part1.parse() == {:set, {"123", "x"}}
  end

  test "parse :and" do
    assert "x AND y -> d" |> String.split() |> Part1.parse() == {:and, {"x", "y", "d"}}
  end

  test "parse :or" do
    assert "x OR y -> e" |> String.split() |> Part1.parse() == {:or, {"x", "y", "e"}}
  end

  test "parse :lshift" do
    assert "x LSHIFT 2 -> f" |> String.split() |> Part1.parse() == {:lshift, {"x", "2", "f"}}
  end

  test "parse :rshift" do
    assert "y RSHIFT 2 -> g" |> String.split() |> Part1.parse() == {:rshift, {"y", "2", "g"}}
  end

  test "parse :not" do
    assert "NOT x -> h" |> String.split() |> Part1.parse() == {:not, {"x", "h"}}
  end

  test "run_circuit :set" do
    assert {:set, {"123", "x"}} |> Part1.run_circuit(%{}) == %{"x" => 123}
    assert {:set, {"123", "x"}} |> Part1.run_circuit(%{"x" => 1}) == %{"x" => 123}
    assert {:set, {"y", "x"}} |> Part1.run_circuit(%{"y" => 1}) == %{"x" => 1, "y" => 1}
  end

  test "run_circuit :and" do
    assert {:and, {"x", "y", "d"}} |> Part1.run_circuit(%{"x" => 123, "y" => 456}) == %{
      "x" => 123,
      "y" => 456,
      "d" => 72
    }
    assert {:and, {"123", "y", "d"}} |> Part1.run_circuit(%{"y" => 456}) == %{
      "y" => 456,
      "d" => 72
    }
  end

  test "run_circuit :or" do
    assert {:or, {"x", "y", "e"}} |> Part1.run_circuit(%{"x" => 123, "y" => 456}) == %{
      "x" => 123,
      "y" => 456,
      "e" => 507
    }
  end

  test "run_circuit :lshift" do
    assert {:lshift, {"x", "2", "f"}} |> Part1.run_circuit(%{"x" => 123}) == %{
      "x" => 123,
      "f" => 492
    }
  end

  test "process :set" do
    assert [{:set, {"123", "x"}}] |> Part1.process([], %{}) == %{"x" => 123}
    assert [{:set, {"y", "x"}}, {:set, {"123", "y"}}] |> Part1.process([], %{}) == %{"x" => 123, "y" => 123}
  end

  @tag :skip
  test "puzzle" do
    assert Part1.parse_instructions()["a"] == 956
  end
end
