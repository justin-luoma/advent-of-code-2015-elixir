defmodule AOC.Day13.Part1 do
  def run() do
    "input/day13"
    |> File.read!()
    |> String.split(".\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> transform()
    |> routes()
    |> Enum.max_by(fn {_, n} -> n end)
    |> elem(1)
  end

  def parse([person, _, "gain", amt, _, _, _, _, _, _, neighbor]) do
    {person, neighbor, amt |> Integer.parse() |> elem(0)}
  end

  def parse([person, _, "lose", amt, _, _, _, _, _, _, neighbor]) do
    {person, neighbor, amt |> Integer.parse() |> elem(0) |> (fn n -> n * -1 end).()}
  end

  def transform(values) do
    values
    |> Enum.reduce(Graph.new(), fn pair, graph ->
      graph
      |> Graph.add_edge(elem(pair, 0), elem(pair, 1), weight: elem(pair, 2))
    end)
  end

  def neighbors(neighbors) do
    Enum.uniq(for n1 <- neighbors, n2 <- neighbors, n1 != n2, do: [n1, n2] |> Enum.sort())
  end

  def example() do
    g = "input/day13example"
    |> File.read!()
    |> String.split(".\n", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> transform()

    g
  end

  def routes(map) do
    cities = Graph.vertices(map)
    paths(map, cities, {[], 0}, []) |> Enum.filter(fn {routes, _} -> length(routes) == length(cities) end)
    |> update(map, [])
  end

  def update([], _g, table), do: table

  def update([{table, val} | rest], g, tmp) do
    f = hd(table)
    l = List.last(table)
    weight = Graph.edge(g, f, l).weight
    weight = weight + Graph.edge(g, l, f).weight
    update(rest, g, [{table, val + weight} | tmp])
  end

  def paths(_map, [], {[], _}, paths), do: paths

  def paths(_map, [], visited , paths) do
    [visited | paths]
  end

  def paths(map, [city | rest], {routes, dist} = visited, paths) when length(routes) == 0 do
      paths(map, rest, visited, paths(map, Graph.neighbors(map, city), {routes ++ [city], dist}, paths))
  end

  def paths(map, [city | rest], {routes, dist} = visited, paths) do
    if Enum.member?(routes, city) do
      paths(map, rest, visited, paths)
    else
      prev = List.last(routes)
      weight = Graph.edge(map, prev, city).weight
      weight = weight + Graph.edge(map, city, prev).weight
      paths(map, rest, visited, paths(map, Graph.neighbors(map, city), {routes ++ [city], dist + weight}, paths))
    end
  end

  # def seating(g, [p | ppl], table) do
  #   Graph.neighbors(g, p)
  #   |> IO.inspect(label: :neighbors)
  #   |> neighbors()
  #   |> Enum.map(fn [n1, n2] ->
  #     [
  #       {p, n1, Graph.edge(g, p, n1).weight},
  #       {p, n2, Graph.edge(g, p, n2).weight}
  #     ]
  #    end)
  # end
end
