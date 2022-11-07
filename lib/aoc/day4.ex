defmodule AOC.Day4 do
  def solve_p1(input) do
    input
    |> _solve_p1(1)
  end

  def solve_p2(input, i) do
    prefix = input <> Integer.to_string(i)
    |> hash_prefix_6()
    case prefix do
      "000000" -> i
      _ -> solve_p2(input, i + 1)
    end
  end

  defp _solve_p1(input, i) do
    prefix = input <> Integer.to_string(i)
    |> hash_prefix()
    case prefix do
      "00000" -> i
      _ -> _solve_p1(input, i + 1)
    end
  end

  defp hash_prefix(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
    |> String.slice(0..4)
  end

  defp hash_prefix_6(input) do
    :crypto.hash(:md5, input)
    |> Base.encode16()
    |> String.slice(0..5)
  end
end
