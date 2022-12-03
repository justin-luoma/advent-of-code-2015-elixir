defmodule AOC.Day23.Part1 do
  require Integer

  # @splitter ~r/(\ |\ \,|\,\ )/

  @regex ~r/(?<ins>\w+)\s(?<reg>\w)?((,\s)?(?<sign>\+|\-)(?<offset>\d+))?/

  # def split(s), do: s |> String.split(@splitter)

  def split(s), do: Regex.run(@regex, s, capture: :all_but_first)

  def solve() do
    "input/day23"
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&split/1)
    |> Enum.map(&parse/1)
    |> program([], 0, 0)
  end

  def part2() do
    "input/day23"
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&split/1)
    |> Enum.map(&parse/1)
    |> program([], 1, 0)
  end

  def parse(["inc", r]), do: {:inc, &(&1 + 1), r}

  def parse(["tpl", r]), do: {:tpl, &(&1 * 3), r}

  def parse(["hlf", r]), do: {:hlf, &div(&1, 2), r}

  def parse(["jmp", _, _, _, "+", offset]),
    do: {:jpm, &jump(&1, &2, offset |> Integer.parse() |> elem(0), true, :forward)}

  def parse(["jmp", _, _, _, "-", offset]),
    do: {:jpm, &jump(&1, &2, offset |> Integer.parse() |> elem(0), true, :back)}

  def parse(["jie", r, _, _, "+", offset]),
    do:
      {:jie, &jump(&1, &2, offset |> Integer.parse() |> elem(0), &3, :forward),
       &Integer.is_even/1, r}

  def parse(["jie", r, _, _, "-", offset]),
    do:
      {:jie, &jump(&1, &2, offset |> Integer.parse() |> elem(0), &3, :back), &Integer.is_even/1,
       r}

  def parse(["jio", r, _, _, "+", offset]),
    do: {:jio, &jump(&1, &2, offset |> Integer.parse() |> elem(0), &3, :forward), &(&1 == 1), r}

  def parse(["jio", r, _, _, "-", offset]),
    do: {:jio, &jump(&1, &2, offset |> Integer.parse() |> elem(0), &3, :back), &(&1 == 1), r}

  def program(queue, ins, a, b) do
    _program(queue, ins, a, b)
  end

  defp _program([], _ins, a, b), do: {a, b}

  defp _program([{_, exp, test, r} = i | queue], ins, a, b) do
    if r == "a" do
      {queue, ins} = exp.([i | queue], ins, test.(a))
      _program(queue, ins, a, b)
    else
      {queue, ins} = exp.([i | queue], ins, test.(b))
      _program(queue, ins, a, b)
    end
  end

  defp _program([{_, exp, r} = i | queue], ins, a, b) do
    if r == "a" do
      _program(queue, [i | ins], exp.(a), b)
    else
      _program(queue, [i | ins], a, exp.(b))
    end
  end

  defp _program([{_, exp} = i | queue], ins, a, b) do
    {queue, ins} = exp.([i | queue], ins)
    _program(queue, ins, a, b)
  end

  defp jump(queue, ins, offset, test, :forward) when test === true do
    move(queue, ins, offset)
  end

  defp jump(queue, ins, offset, test, :back) when test === true do
    {ins, queue} = move(ins, queue, offset)
    {queue, ins}
  end

  defp jump([h | queue], ins, _offset, test, _) when test === false, do: {queue, [h | ins]}

  defp move(from, to, count) when count == 0, do: {from, to}

  defp move([h | t], to, count) do
    move(t, [h | to], count - 1)
  end
end
