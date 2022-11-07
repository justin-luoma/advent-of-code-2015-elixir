defmodule AOC.Day11.Part1 do
  @pairs ~r/([a-z])\1.*?([a-z])\2/
  @bad ~r/[iol]/

  def valid?([_ | [_ | []]]), do: false
  def valid?([a | [b | rest]]) when a + 1 == b and b + 1 == hd(rest), do: true
  def valid?([_ | rest]), do: valid?(rest)
  def valid?(input), do: to_charlist(input)
  # def valid?([a | rest])

  def match?(s), do: not(s =~ @bad) && s =~ @pairs

  def increment([c | _]), do: [c + 1]

  def next(old) do
    charlist = old
    |> String.split("", trim: true)

    len = length(charlist)
    charlist
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {e, i}, map -> Map.put_new(map, i, e) end)
    |> _next(len, len - 1)
  end

  defp _next(letters, len, cur) do
    # IO.inspect(letters)
    {letters, _cur} = _increment(letters, len, cur)
    if check(letters, len - 1) do
      combine(letters, len - 1, []) |> to_string()
    else
      # combine(letters, len - 1, []) |> to_string()
      _next(letters, len, len - 1)
    end
  end

  def check(letters, last) do
    seq = combine(letters, last, [])
    match?(seq |> to_string()) && valid?(seq)
  end

  defp combine(_letters, i, seq) when i < 0, do: seq |> List.to_charlist()

  defp combine(letters, i, seq), do: combine(letters, i - 1, [letters[i] | seq])

  defp _increment(letters, len, cur) do
    [letter|_] = letters[cur] |> to_charlist()
    if letter == ?z do
      # [letter|_] = letters[cur - 1] |> to_charlist()
      # IO.inspect(letter)
      # {%{letters | cur => <<97>>, cur-1 => <<letter + 1>>}, len - 1}
      _increment(%{letters | cur => <<97>>}, len, cur - 1)
     else
      {%{letters | cur => <<letter + 1>>}, len - 1}
     end
  end

  def rotate(old) do
    old
    |> to_charlist()
    |> Enum.reverse()
    |> _rotate()
  end

  defp _rotate([?z | [c | rest]]) when c != ?z do
    letter = [c] |> to_charlist() |> increment()
    l = [?z | [letter | rest]]
    s = List.to_string(l)
    if match?(s) do
      s = String.reverse(s)
      if valid?(s) do
        s
      else
        _rotate(l)
      end
    else
      _rotate(l)
    end
  end
end
