defmodule Day6Test do
  use ExUnit.Case, async: true
  alias AOC.Day6

  test "parse_input turn on" do
    out =
      "turn on 106,353 through 236,374"
      |> String.split()
      |> Day6.parse_input()

    assert out == {:on, {106..236, 353..374}}
  end

  test "parse_input turn off" do
    out =
      "turn off 106,353 through 236,374"
      |> String.split()
      |> Day6.parse_input()

    assert out == {:off, {106..236, 353..374}}
  end

  test "parse_input toggle" do
    out =
      "toggle 106,353 through 236,374"
      |> String.split()
      |> Day6.parse_input()

    assert out == {:toggle, {106..236, 353..374}}
  end

  test "update_grid :on new grid" do
    assert Day6.update_grid({:on, {0..0, 0..0}}, %{}) == %{{0, 0} => true}
  end

  test "update_grid :on existing grid" do
    assert Day6.update_grid({:on, {1..1, 1..1}}, %{{0, 0} => true}) == %{
             {0, 0} => true,
             {1, 1} => true
           }
  end

  test "update_grid :off new grid" do
    assert Day6.update_grid({:off, {0..1, 0..1}}, %{}) == %{}
  end

  test "update_grid :off existing grid" do
    assert Day6.update_grid({:off, {0..1, 0..1}}, %{
             {0, 0} => true,
             {1, 1} => true,
             {2, 2} => true
           }) == %{{2, 2} => true}
  end

  test "update_grid :toggle new grid" do
    assert Day6.update_grid({:toggle, {0..0, 0..1}}, %{}) == %{{0, 0} => true, {0, 1} => true}
  end

  test "update_grid :toggle update grid" do
    assert Day6.update_grid({:toggle, {0..0, 0..1}}, %{{0, 0} => true}) == %{{0, 1} => true}
  end

  @tag :skip
  test "puzzle p1" do
    assert Day6.run_p1() == 400410
  end
end
