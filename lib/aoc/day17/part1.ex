defmodule AOC.Day17.Part1 do
  @r ~r/\,\W(\d+)/

  def solve_part1() do
    "input/day17"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> use_combo(150)
  end

  def file_processor() do
    File.stream!("../../rust/aoc/part1.txt")
    # |> Enum.take(1)
    |> Enum.map(fn e ->
      Regex.scan(@r, e)
      |> Enum.map(fn e -> Enum.reverse(e) |> hd() |> Integer.parse() |> elem(0) end)
      |> Enum.sort()
    end)
    |> list_of_parsed_lines()
  end

  def list_of_parsed_lines(l) do
    l
    |> Enum.reduce(MapSet.new([]), fn e, acc ->
      e |> List.to_tuple() |> (fn t -> MapSet.put(acc, t) end).()
    end)
  end

  # import Integer, only: [is_even: 1]

  @example 25
  @part1 150

  # @value 150

  def combine([], acc), do: acc

  def combine([h|t], acc) when length(h) == 0, do: combine(t, acc)

  def combine([h|t], acc), do: combine(t, [h|acc])

  def use_combo(l, t) do
    _use_combo(l, 2, length(l) - 1, t, [])
  end

  defp _use_combo(_l, i, loop, _t, acc) when i > loop, do: acc

  defp _use_combo(l, i, loop, t, acc) do
    combos = n_combo(i, l)
    |> Enum.filter(fn e -> Enum.sum(e) == t end)

    # IO.inspect(combos, label: :combos)

    if Enum.empty?(combos) do
      _use_combo(l, i + 1, loop, t, acc)
    else
      _use_combo(l, i + 1, loop, t, combine(combos, acc))
    end

  end

  def n_combo(0, _list), do: [[]]

  def n_combo(_, []), do: []

  def n_combo(n, [h|t]) do
    list = for l <- n_combo(n - 1, t), do: [h|l]

    list ++ n_combo(n, t)
  end

  # def generate(k, _a, acc) when k == 1, do: acc

  # def generate(k, a, acc) do
  #   loop(0, k - 1, k, generate(k - 1, a))
  # end

  # def loop(i, max, _k, l) when i == max, do: l

  # def loop(i, max, k, l) when is_even(k) do
  #   a = Enum.at(l, i)
  #   b = Enum.at(l, k - 1)

  #   if a == b do
  #     loop(i + 1, max, k, l)
  #     generate(k - 1, l)
  #   else
  #     l =
  #       l
  #       |> List.replace_at(i, b)
  #       |> List.replace_at(k - 1, a)

  #     loop(i + 1, max, k, l)
  #     generate(k - 1, l)
  #   end
  # end

  # def loop(i, max, k, l) do
  #   a = hd(l)
  #   b = Enum.at(l, k - 1)

  #   if a == b do
  #     loop(i + 1, max, k, l)
  #   else
  #     [_ | tail] = l
  #     l = [b | tail]

  #     l =
  #       l
  #       |> List.replace_at(k - 1, a)

  #     loop(i + 1, max, k, l)
  #   end

  #   generate(k - 1, l)
  # end

  def run() do
    "input/day17"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.with_index()

    # |> Enum.map(fn {{h, h_i} = head, l} ->
    #   {head,
    #    for {i, i_i} = ii <- l,
    #        {j, j_j} = jj <- l -- [ii],
    #        h + i == @part1 || h + j == @part1 || h + i + j == @part1,
    #        uniq: true do
    #      cond do
    #        i + h == @part1 ->
    #          {[h_i, i_i] |> Enum.sort() |> List.to_tuple(), ii}

    #        j + h == @part1 ->
    #         {[h_i, j_j] |> Enum.sort() |> List.to_tuple(), jj}

    #        true ->
    #          {[h_i, i_i, j_j] |> Enum.sort() |> List.to_tuple(), ii, jj}
    #      end
    #    end}

    #   # l
    #   # |> Enum.reduce({[], []}, fn {h, i}, {acc, })
    # end)
    # |> Enum.map(fn {_, a} ->
    #   a |> Enum.map(fn e ->
    #     e |> elem(0)
    #    end)
    #  end)
    #  |> List.flatten()
    #  |> Enum.uniq()
  end

  def example() do
    "input/day17example"
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n", trim: true)
    |> Enum.map(&Integer.parse/1)
    |> Enum.map(&elem(&1, 0))
    |> Enum.with_index()
    |> with_index()

    # |> Enum.map(fn {{h, h_i} = head, l} ->
    #   {head,
    #    for {i, i_i} = ii <- l,
    #        {j, j_j} = jj <- l -- [ii],
    #        h + i == @example || h + j == @example || h + i + j == @example,
    #        uniq: true do
    #      cond do
    #        i + h == @example ->
    #          {[h_i, i_i] |> Enum.sort() |> List.to_tuple(), ii}

    #        j + h == @example ->
    #         {[h_i, j_j] |> Enum.sort() |> List.to_tuple(), jj}

    #        true ->
    #          {[h_i, i_i, j_j] |> Enum.sort() |> List.to_tuple(), ii, jj}
    #      end
    #    end}

    #   # l
    #   # |> Enum.reduce({[], []}, fn {h, i}, {acc, })
    # end)
    # |> Enum.map(fn {_, a} ->
    #   a |> Enum.map(fn e ->
    #     e |> elem(0)
    #    end)
    #  end)
    #  |> List.flatten()
    #  |> Enum.uniq()

    # |> Enum.reduce([], fn
    #   n, [] ->
    #     [{n, [n]}]

    #   n, acc ->
    #     [{n, [n]} | transform(n, acc, [])]
    # end)
  end

  def with_index(l), do: _with_index(l, l, [])

  defp _with_index([], _l, acc), do: acc

  defp _with_index([{h, _i} = head | t], l, acc) do
    _with_index(t, l, [
      (l -- [head])
      |> Enum.filter(fn {e, _ei} ->
        e + h <= @example
      end)
      |> Enum.reduce({head, []}, fn e, {h, acc} ->
        {h, [e | acc]}
      end)
      | acc
    ])
  end

  def transform(_n, [], acc), do: acc

  def transform(n, [{h, v} | rest], acc) do
    transform(n, rest, [t(n, h, v, []) | acc])
  end

  def t(n, h, v, []) when n + h > @example do
    {h, v}
  end

  def t(n, h, [], acc), do: {h, [n + h | acc]}

  def t(n, h, [v | rest], acc) when n + h <= @example and n + v <= @example do
    t(n, h, rest, [v + n | acc])
  end

  def t(n, h, [v | rest], acc) when n + h <= @example do
    t(n, h, rest, [v | acc])
  end

  def process(v) do
    0..(length(v) - 1)
    |> Enum.to_list()
    |> perms()
    |> IO.inspect()
    |> Enum.reduce([], fn i, acc ->
      [indexes(i, v, {0, []}) | acc]
    end)
    |> Enum.filter(fn {n, _} -> n == @part1 end)
    |> Enum.map(fn {n, a} -> {n, Enum.sort(a)} end)
    |> Enum.sort()
    |> Enum.dedup()
  end

  def indexes([], _, acc), do: acc

  def indexes([i | t], v, {acc, l}) when acc < @part1 do
    val = Enum.at(v, i)

    if val + acc <= @part1 do
      indexes(t, v, {acc + val, [val | l]})
    else
      {acc, [val | l]}
    end
  end

  def indexes(_, _, acc), do: acc

  def perms([]), do: [[]]

  def perms(l) do
    for h <- l, t <- perms(l -- [h]), uniq: true, do: [h | t]
  end

  def reduce(h, t) when is_list(t) do
    Enum.reduce(t, h, fn e, acc ->
      if acc + e <= @part1 do
        acc + e
      else
        acc
      end
    end)
  end

  def reduce(h, t) when h + t <= @part1, do: h + t
  def reduce(_h, t), do: t

  # def t(n, h, [v|rest], acc) do
  #   t(n, h, rest, [{h, [v, n]} | acc])
  # end

  def update(_n, [], acc), do: acc

  def update(n, [{h, v} | t], acc) when n + h <= @example and hd(v) + n == 1 do
    update(n, t, [{h, [hd(v) + n]} | acc])
  end

  def update(n, [{h, v} | t], acc) when n + h < @example do
    update(n, t, [{h, _update(n, v, [])} | acc])
  end

  def update(n, [h | t], acc) do
    update(n, t, [h | acc])
  end

  defp _update(_n, [], acc), do: acc

  defp _update(n, [v | rest], acc) when n + v <= @example do
    _update(n, rest, [n + v | acc])
  end

  defp _update(n, [v | rest], acc) do
    _update(n, rest, [v | acc])
  end
end
