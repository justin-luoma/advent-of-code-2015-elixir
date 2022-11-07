defmodule AOC.Day11.Part1Test do
	use ExUnit.Case, async: true
	alias AOC.Day11.Part1

  test "valid?" do
    assert Part1.valid?('abc') == true
    assert Part1.valid?('hijklmmn') == true
    assert Part1.valid?('aaaklmmn') == true
    assert Part1.valid?('aaaklmmn') == true
  end

  test "match?" do
    assert Part1.match?("abcdffaa") == true
    assert Part1.match?("ghjaabcc") == true
    assert Part1.match?("iabcaaff") == false
    assert Part1.match?("labcaaff") == false
    assert Part1.match?("oabcaaff") == false
  end

  test "rotate" do
    assert Part1.rotate("aaabcbz") == "aaabccz"
  end

  test "check" do
    assert Part1.check(%{0 => "a", 1 => "a", 2 => "b", 3 => "c", 4 => "c", 5 => "z"}, 5) == true
  end

  @tag :skip
  test "puzzle 1" do
    assert Part1.next("hxbxwxba") == "hxbxxyzz"
  end

  test "puzzle 2" do
    assert Part1.next("hxbxxyzz") == "hxcaabcc"
  end

  @tag :skip
  test "next" do
    assert Part1.next("aaabcbz") == "aaabcca"
    assert Part1.next("abcdefgh") == "abcdffaa"
    assert Part1.next("ghijklmn") == "ghjaabcc"
  end
end
