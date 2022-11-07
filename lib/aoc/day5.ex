defmodule AOC.Day5 do
  @c1 ~r/(.*[aeiou]){3,}/
  @c2 ~r/(.)\1{1,}/
  @c3 ~r/ab|cd|pq|xy/

  def test(input), do: input =~ @c1 && input =~ @c2 && not(input =~ @c3)

  def solve_p1() do
    "input/day5"
    |> File.stream!
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&test/1)
    |> Enum.count()
  end

  @pair ~r/([[:lower:]][[:lower:]]).*\1/
  @repeated ~r/([[:lower:]])[[:lower:]]\1/

  def test_p2(input), do: input =~ @pair && input =~ @repeated

  def solve_p2() do
    "input/day5"
    |> File.stream!
    |> Enum.map(&String.trim/1)
    |> Enum.filter(&test_p2/1)
    |> Enum.count()
  end
end
