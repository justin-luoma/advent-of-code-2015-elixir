defmodule AOC.Day14.Part1 do
  def example() do
    "input/day14example"
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> advance(1, [])
  end

  def run() do
    "input/day14"
    |> File.read!()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> advance(2503, [])
  end

  def advance([], _sec, state), do: state

  def advance([{name, speed, dur, _rest} | r], sec, state) when sec <= dur do
    advance(r, sec, [{name, :flying, speed * sec} | state])
  end

  def advance([{name, speed, dur, rest} | r], sec, state) when sec <= dur + rest do
    advance(r, sec, [{name, :resting, speed * dur} | state])
  end

  def advance([{name, speed, dur, rest} | r], sec, state) do
    cycle = dur + rest
    cycles = div(sec, cycle)
    rem = rem(sec, cycle)

    dist = dur * cycles * speed

    if rem < dur do
      advance(r, sec, [{name, :flying, dist + rem * speed}  | state])
    else
      advance(r, sec, [{name, :resting, dist + dur * speed} | state])
    end
  end

  def parse([name, _, _, speed, _, _, dur, _, _, _, _, _, _, rest, _]) do
    {name, speed |> Integer.parse() |> elem(0), dur |> Integer.parse() |> elem(0),
     rest |> Integer.parse() |> elem(0)}
  end
end
