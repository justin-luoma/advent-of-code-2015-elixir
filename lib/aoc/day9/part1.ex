defmodule AOC.Day9.Part1 do
  def run() do
    "input/day9"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> Enum.reduce(Graph.new(), fn route, graph ->
      Graph.add_edges(graph, [
        {elem(route, 0), elem(route, 1), weight: elem(route, 2)},
        {elem(route, 1), elem(route, 0), weight: elem(route, 2)}
      ])
    end)
    |> routes()
    # |> Enum.map(fn {_, dist} -> dist end)
    |> Enum.min_by(fn ({_, dist}) -> dist end)
  end

  def parse([from, _, to, _, dis]) do
    {from, to, Integer.parse(dis) |> elem(0)}
  end

  def test() do
    # Graph.new()
    # |> Graph.add_edge(:london, :dublin, weight: 464)
    # |> Graph.add_edge(:london, :belfast, weight: 815)
    # |> Graph.add_edge(:dublin, :belfast, weight: 141)
    "input/day9example"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> Enum.reduce(Graph.new(), fn route, graph ->
      Graph.add_edges(graph, [
        {elem(route, 0), elem(route, 1), weight: elem(route, 2)},
        {elem(route, 1), elem(route, 0), weight: elem(route, 2)}
      ])
    end)
  end

  def routes(map) do
    cities = Graph.vertices(map)
    paths(map, cities, {[], 0}, []) |> Enum.filter(fn {routes, _} -> length(routes) == length(cities) end)
  end

  def paths(_map, [], {[], _}, paths), do: paths

  def paths(_map, [], visited , paths), do: [visited | paths]

  def paths(map, [city | rest], {routes, dist} = visited, paths) when length(routes) == 0 do
      paths(map, rest, visited, paths(map, Graph.neighbors(map, city), {routes ++ [city], dist}, paths))
  end

  def paths(map, [city | rest], {routes, dist} = visited, paths) do
    if Enum.member?(routes, city) do
      paths(map, rest, visited, paths)
    else
      prev = List.last(routes)
      weight = Graph.edge(map, prev, city).weight
      paths(map, rest, visited, paths(map, Graph.neighbors(map, city), {routes ++ [city], dist + weight}, paths))
    end
  end

  # def complete_map(map) do
  #   keys = Map.keys(map)
  #   first = hd(keys)
  #   _complete_map(map, keys, map[first])
  # end

  # defp _complete_map(map, [_ | []], []), do: map

  # defp _complete_map(map, [_ | rest], []) do
  #   next = hd(rest)
  #   _complete_map(map, rest, map[next])
  # end

  # defp _complete_map(map, [key | _] = keys, [value | others]) do
  #   {city, dist} = value
  #   if Map.has_key?(map, city) do
  #     routes = map[city]

  #     _complete_map(map, keys, others)
  #   else
  #     map = Map.put_new(map, city, {key, dist})
  #     _complete_map(map, keys, others)
  #   end
  # end

  # def expand(map, [next | rest], visited, {routes, dis} = route) do
  #   {city, val} = next

  #   if Enum.member?(visited, city) do
  #     expand(map, rest, visited, route)
  #   else
  #     expand(map, rest, [city | visited], {routes ++ [city], dis + val})
  #   end
  # end

  defp reducer(route, map) do
    val = {elem(route, 1), elem(route, 2)}

    map
    |> Map.update(
      elem(route, 0),
      [val],
      fn old -> [val | old] end
    )
  end
end
