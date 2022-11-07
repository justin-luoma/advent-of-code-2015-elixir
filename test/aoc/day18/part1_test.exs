defmodule AOC.Day18.Part1Test do
	use ExUnit.Case
	alias AOC.Day18.Part1

  test "neighbors top left" do
    assert (Part1.neighbors({1, 1}, 4) |> Enum.sort()) == Enum.sort([{2, 1}, {1, 2}, {2, 2}])
    assert (Part1.neighbors({1, 1}, 6) |> Enum.sort()) == Enum.sort([{2, 1}, {1, 2}, {2, 2}])
  end

  test "neighbors top right" do
    assert (Part1.neighbors({4, 1}, 4) |> Enum.sort()) == Enum.sort([{3, 1}, {3, 2}, {4, 2}])
    assert (Part1.neighbors({6, 1}, 6) |> Enum.sort()) == Enum.sort([{5, 1}, {5, 2}, {6, 2}])
  end

  test "neighbors bottom right" do
    assert (Part1.neighbors({4, 4}, 4) |> Enum.sort()) == Enum.sort([{4, 3}, {3, 3}, {3, 4}])
    assert (Part1.neighbors({6, 6}, 6) |> Enum.sort()) == Enum.sort([{6, 5}, {5, 5}, {5, 6}])
  end

  test "neighbors bottom left" do
    assert (Part1.neighbors({1, 4}, 4) |> Enum.sort()) == Enum.sort([{1, 3}, {2, 3}, {2, 4}])
    assert (Part1.neighbors({1, 6}, 6) |> Enum.sort()) == Enum.sort([{1, 5}, {2, 5}, {2, 6}])
  end

  test "neighbors left edge" do
    assert (Part1.neighbors({1, 5}, 6) |> Enum.sort()) == Enum.sort([{1, 6}, {2, 5}, {1, 4}, {2, 4}, {2, 6}])
  end

  test "neighbors right edge" do
    assert (Part1.neighbors({6, 5}, 6) |> Enum.sort()) == Enum.sort([{6, 6}, {5, 6}, {5, 5}, {5, 4}, {6, 4}])
  end

  test "neighbors top edge" do
    assert (Part1.neighbors({5, 1}, 6) |> Enum.sort()) == Enum.sort([{6,1}, {5, 2}, {4, 2}, {6, 2}, {4, 1}])
  end

  test "neighbors bottom edge" do
    assert (Part1.neighbors({2, 6}, 6) |> Enum.sort()) == Enum.sort([{1,6}, {1, 5}, {2, 5}, {3, 5}, {3, 6}])
  end

  test "neighbors no edge" do
    assert (Part1.neighbors({2, 5}, 6) |> Enum.sort()) == Enum.sort([{1,6}, {1, 5}, {1, 4}, {2, 4}, {3, 4}, {3, 5}, {3, 6}, {2, 6}])
  end
end
