defmodule AOC.Day2 do
  def paper_needed({l, w, h}) do
    _paper_needed(l * w, w * h, l * h)
  end

  defp _paper_needed(a, a, a) do
    6 * a + a
  end

  defp _paper_needed(a, a, c) do
    cond do
      a < c ->
        4 * a + 2 * c + a

      c < a ->
        4 * a + 2 * c + c
    end
  end

  defp _paper_needed(a, b, a) do
    cond do
      a < b ->
        4 * a + 2 * b + a

      b < a ->
        4 * a + 2 * b + b
    end
  end

  defp _paper_needed(a, b, b) do
    cond do
      a < b ->
        2 * a + 4 * b + a

      b < a ->
        2 * a + 4 * b + b
    end
  end

  defp _paper_needed(a, b, c) do
    cond do
      a < b && a < c ->
        2 * a + 2 * b + 2 * c + a

      b < a && b < c ->
        2 * a + 2 * b + 2 * c + b

      c < a && c < b ->
        2 * a + 2 * b + 2 * c + c
    end
  end

  def ribbon_needed({l, w, h}) do
    Enum.sort([l, w, h])
    |> _ribbon_needed()
  end

  defp _ribbon_needed([a, b, c]) do
    2 * a + 2 * b + a * b *c
  end

  def run(filepath) do
    filepath
    |> File.stream!
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split(&1, "x"))
    |> Enum.map(fn [a, b, c] -> {elem(Integer.parse(a), 0), elem(Integer.parse(b), 0), elem(Integer.parse(c), 0)} end)
    |> Enum.map(&ribbon_needed/1)
    |> Enum.sum()
  end
end
