defmodule AOC.Day13.Part2 do
  alias AOC.Day13.Part1

  def run() do
    "input/day13"
    |> File.read!()
    |> String.split(".\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&Part1.parse/1)
    |> Part1.transform()
    |> add_me()
    |> Part1.routes()
    |> Enum.max_by(fn {_, n} -> n end)
    |> elem(1)
  end

  def add_me(g) do
    Graph.vertices(g)
    |> _add_me(g)
  end

  defp _add_me([], g), do: g

  defp _add_me([p | ppl], g) do
    _add_me(
      ppl,
      Graph.add_edges(g, [
        {"Me", p, weight: 0},
        {p, "Me", weight: 0}
      ])
    )
  end
end
