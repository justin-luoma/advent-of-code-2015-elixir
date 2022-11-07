defmodule AOC.Day19.Part2 do
  def example() do
    {perms, molecules, es} = "input/day19examplepart2"
    |> parse()

    # step("H", {perms, "HOHOHO" |> extract_molecules()})
    # |> permute()
    # |> Enum.map(fn e -> List.to_string(e) end)
    # |> Enum.uniq()
  end

  # https://old.reddit.com/r/adventofcode/comments/3xflz8/day_19_solutions/cy4etju/
  def solve() do
    {_perms, molecules, _es} = "input/day19"
    |> parse()

    molecules = Map.values(molecules)

    total = molecules |> length()
    control = molecules |> Enum.count(fn e -> e == "Rn" || e == "Ar" end)
    ys = molecules |> Enum.count(fn e -> e == "Y" end)

    total - control - 2*ys - 1
    # step("HF", {perms, molecules})
    # |> permute()
    # |> Enum.map(fn e -> List.to_string(e) end)
    # |> Enum.uniq()
  end

  def deconstruct({perms, molecule, es}) do
    combine(molecule, "", 10000) |> List.to_string()
  end

  def parse(file) do
    file
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({[], "", []}, fn s, {replacements, input, e} ->
      if String.contains?(s, "=>") do
        [m, r] = s |> String.split(" => ", trim: true)

        if m == "e" do
          {replacements, input, [{m, r} | e]}
        else
          {[{m, r} | replacements], input, e}
        end
      else
        if String.length(s) != 0 do
          {replacements, extract_molecules(s), e}
        else
          {replacements, input, e}
        end
      end
    end)
  end

  def extract_molecules(s) do
    Regex.scan(~r/(e|[A-Z][abcdfghijklmnoqrstuvwxyz]?)/, s)
    |> Enum.map(fn [_, mol] -> mol end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {e, i}, acc ->
      Map.put_new(acc, i, e)
    end)
  end

  def step(e, {perms, final}) do
    permute({perms, extract_molecules(e)})
    |> molecules_from_permute()
    |> _step(perms, final, 2, [])

    # |> _step(perms, final, 2)
  end

  defp _step([], perms, final, i, processed) do
    processed
    |> Enum.map(fn input -> combine(input, "r", 10000) |> List.to_string() end)
    |> Enum.map(fn seq -> extract_molecules(seq) end)
    |> permute_all(perms, [])
    |> _step(perms, final, i + 1, [])
    # |> Enum.map(fn molecule -> permute({perms, molecule}) |> molecules_from_permute() end)
  end

  defp _step([h | t], perms, final, i, processed) do
    cur = combine(h, h, 10000) |> List.to_string()

    # IO.inspect(h, label: :head)

    if h == final || i == 1000 do
      {cur, i}
    else
      _step(t, perms, final, i, [h | processed])
    end
  end

  def permute_all([], _perms, acc), do: acc |> Enum.uniq()

  def permute_all([h | t], perms, acc) do
    permute_all(t, perms, (permute({perms, h}) |> molecules_from_permute()) ++ acc)
  end

  defp molecules_from_permute(permutes) do
    permutes
    |> Enum.map(fn l -> List.to_string(l) end)
    |> Enum.map(&extract_molecules/1)
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
    # increment steps
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
