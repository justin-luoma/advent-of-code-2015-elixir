defmodule AOC.Day8.Part1 do
  @input "input/day8"

  def parse do
    @input
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def process_bin do
    parse()
    |> Enum.reduce(0, fn line, a ->
      a + (String.length(line) - process_bin(line, -2))
    end)
  end

  def expand_bin do
    parse()
    |> Enum.reduce(0, fn line, a ->
      a + (expand_bin(line, 2) - String.length(line))
    end)
  end

  defp process_bin(<<"">>, mem), do: mem

  defp process_bin(<<"\\x", a, b, rest::binary>>, mem) do
    case valid_hex?(a, b) do
      true -> process_bin(rest, mem + 1)
      false -> process_bin(<<a, b, rest::binary>>, mem + 1)
    end
  end

  defp process_bin(<<"\\", "\"", rest::binary>>, mem), do: process_bin(rest, mem + 1)
  defp process_bin(<<"\\\\", rest::binary>>, mem), do: process_bin(rest, mem + 1)
  defp process_bin(<<_other, rest::binary>>, mem), do: process_bin(rest, mem + 1)

  defp expand_bin(<<"">>, inc), do: inc
  defp expand_bin(<<"\"", rest::binary>>, inc), do: expand_bin(rest, inc + 2)
  defp expand_bin(<<"\\", rest::binary>>, inc), do: expand_bin(rest, inc + 2)
  defp expand_bin(<<_other, rest::binary>>, inc), do: expand_bin(rest, inc + 1)

  defp valid_hex?(a, b) do
    Enum.all?([a, b], fn c -> c in '0123456789abcdef' end)
  end

  def solve() do
    # File.stream!("input/day8") |> Enum.map(&String.trim/1) |> Enum.map(&String.length/1)
    {c_size, m_size} =
      Enum.reduce(File.stream!("input/day8"), {0, 0}, fn line, {c_size, m_size} ->
        line = String.trim(line)
        {ret, _} = Code.eval_string(line)
        {c_size + String.length(line), m_size + String.length(ret)}
      end)

    IO.puts("Part 1: #{c_size - m_size}")

    # Part 2
    {c_size, nc_size} =
      Enum.reduce(File.stream!("input/day8"), {0, 0}, fn line, {c_size, nc_size} ->
        line = String.trim(line)
        new_code = Macro.to_string(quote do: unquote(line))
        {c_size + String.length(line), nc_size + String.length(new_code)}
      end)

    IO.puts("Part 2: #{nc_size - c_size}")
  end
end
