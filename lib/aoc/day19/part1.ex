defmodule AOC.Day19.Part1 do
  def example() do
    "input/day19example"
    |> parse()
    |> permute()
    |> Enum.map(fn e -> List.to_string(e) end)
    |> Enum.uniq()
  end

  def solve() do
    "input/day19"
    |> parse()
    |> permute()
    |> Enum.map(fn e -> List.to_string(e) end)
    |> Enum.uniq()
  end

  def parse(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({[], ""}, fn s, {replacements, input} ->
      if String.contains?(s, "=>") do
        [m, r] = s |> String.split(" => ", trim: true)
        {[{m, r} | replacements], input}
      else
        if String.length(s) != 0 do
          {replacements,
           Regex.scan(~r/(e|[A-Z][abcdfghijklmnoqrstuvwxyz]?)/, s)
           |> Enum.map(fn [_, mol] -> mol end)
           |> Enum.with_index()
           |> Enum.reduce(%{}, fn {e, i}, acc ->
             Map.put_new(acc, i, e)
           end)}
        else
          {replacements, input}
        end
      end
    end)
  end

  # {[{"O", "HH"}], %{0 => "H"}}
  def permute({perms, input} = arg) do
    _permute(perms, arg, 0, Map.get(input, 0), [])
  end

  defp _permute([], {perms, input} = arg, i, _match, acc) do
    if Map.has_key?(input, i + 1) do
      _permute(perms, arg, i + 1, Map.get(input, i + 1), acc)
    else
      acc
    end
  end

  defp _permute([{mol, replace} | t], {_perms, input} = arg, i, match, acc) when mol == match do
    _permute(t, arg, i, match, [combine(input, replace, i) | acc])
  end

  defp _permute([_ | t], arg, i, match, acc) do
    _permute(t, arg, i, match, acc)
  end

  def combine(input, r, ri) do
    _combine(input, r, 0, ri, [])
  end

  defp _combine(input, r, i, ri, acc) when i == ri do
    _combine(input, r, i + 1, ri, [r | acc])
  end

  defp _combine(input, r, i, ri, acc) do
    if Map.has_key?(input, i) do
      _combine(input, r, i + 1, ri, [Map.get(input, i) | acc])
    else
      acc |> Enum.reverse()
    end
  end
end
