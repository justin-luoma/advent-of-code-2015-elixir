defmodule Day5Test do
  use ExUnit.Case, async: true
  alias AOC.Day5

  test "example 1" do
    assert Day5.test("ugknbfddgicrmopn") == true
  end

  test "example 2" do
    assert Day5.test("aaa") == true
  end

  test "example 3" do
    assert Day5.test("jchzalrnumimnmhp") == false
  end

  test "example 4" do
    assert Day5.test("haegwjzuvuyypxyu") == false
  end

  test "example 5" do
    assert Day5.test("dvszwmarrgswjxmb") == false
  end

  test "puzzle" do
    assert Day5.solve_p1() == 236
  end

  test "p2 example 1" do
    assert Day5.test_p2("qjhvhtzxzqqjkmpb") == true
  end

  test "p2 example 2" do
    assert Day5.test_p2("xxyxx") == true
  end

  test "p2 example 3" do
    assert Day5.test_p2("uurcxstgmygtbstg") == false
  end

  test "p2 example 4" do
    assert Day5.test_p2("ieodomkazucvgmuy") == false
  end

  test "p2 puzzle" do
    assert Day5.solve_p2() == 51
  end
end
