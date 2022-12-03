defmodule AOC.Day23.Part1Test do
  use ExUnit.Case, async: true
  alias AOC.Day23.Part1

  test "program inc" do
    queue = [Part1.split("inc a") |> Part1.parse()]
    assert Part1.program(queue, [], 0, 0) == {1, 0}

    queue = queue ++ [Part1.split("inc b") |> Part1.parse()]
    assert Part1.program(queue, [], 0, 0) == {1, 1}

    queue = queue ++ [Part1.split("inc a") |> Part1.parse()]
    assert Part1.program(queue, [], 0, 0) == {2, 1}
  end

  test "program hlf" do
    queue = [Part1.split("hlf a") |> Part1.parse()]
    assert Part1.program(queue, [], 2, 0) == {1, 0}

    queue = [Part1.split("hlf b") |> Part1.parse()]
    assert Part1.program(queue, [], 0, 2) == {0, 1}
  end

  test "program tpl" do
    queue = [Part1.split("tpl a") |> Part1.parse()]
    assert Part1.program(queue, [], 1, 0) == {3, 0}

    queue = [Part1.split("tpl b") |> Part1.parse()]
    assert Part1.program(queue, [], 0, 2) == {0, 6}
  end

  test "program jie" do
    queue = [
      Part1.split("jie a, +2") |> Part1.parse(),
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("hlf a") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 2, 0) == {1, 0}

    queue = [
      # Part1.split("jie a, +2") |> Part1.parse(),
      Part1.split("inc a") |> Part1.parse(),
      # Part1.split("hlf a") |> Part1.parse(),
      Part1.split("jie a, -1") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 2, 0) == {3, 0}

    queue = [
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("jie a, -1") |> Part1.parse(),
      Part1.split("tpl a") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 1, 0) == {9, 0}
  end

  test "program jio" do
    queue = [
      Part1.split("jio a, +2") |> Part1.parse(),
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("tpl a") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 0, 0) == {3, 0}

    queue = [
      Part1.split("jio a, +2") |> Part1.parse(),
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("tpl a") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 1, 0) == {3, 0}

    queue = [
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("tpl a") |> Part1.parse(),
      Part1.split("jio a, -2") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 0, 0) == {3, 0}
  end

  test "example" do
    queue = [
      Part1.split("inc a") |> Part1.parse(),
      Part1.split("jio a, +2") |> Part1.parse(),
      Part1.split("tpl a") |> Part1.parse(),
      Part1.split("inc a") |> Part1.parse()
    ]

    assert Part1.program(queue, [], 0, 0) == {2, 0}
  end
end
