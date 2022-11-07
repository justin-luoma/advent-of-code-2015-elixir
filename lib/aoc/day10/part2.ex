defmodule AOC.Day10.Part2 do
  def test(input, i), do: _test(Integer.digits(input), 0, i)

  defp _test(input, i, loop) when i == loop, do: input

  defp _test(input, i, loop) do
    # IO.inspect({i,input})
    j = i + 1

    case split(input) do
      [a, b] ->
        case check_split(a, b, input) do
          {:ok, a, b} ->
            _test(a, j, loop) ++ _test(b, j, loop)

          {:no, input} ->
            _test(input, j, loop)
        end

      # IO.inspect({a, b}, label: :raw)
      # a = _morph(a, 1, [], 1, 1)
      # a2 = _morph(a, 1, [], 1, 1)
      # b = _morph(b, 1, [], 1, 1)
      # b2 = _morph(b, 1, [], 1, 1)
      # test = _morph(input, 1, [], 1, 1)
      # test2 = _morph(test, 1, [], 1, 1)
      # # IO.inspect({a2, b2, test2}, label: :morph)

      # if a2 ++ b2 == test2 do
      #   _test(a, j, loop) ++ _test(b, j, loop)
      # else
      #   _test(test, j, loop)
      # end

      a ->
        _morph(a |> List.flatten() , 1, [], 1, 1) |> _test(j, loop)

      # l ->
      #   len = div(length(l), 2)

      #   l
      #   |> Enum.split(len)
      #   # |> IO.inspect()
      #   |> (fn {a, b} ->
      #         case check_split(a |> List.flatten(), b |> List.flatten(), input) do
      #           {:ok, a, b} ->
      #             _test(a, j, loop) ++
      #               _test(b, j, loop)

      #           {:no, input} ->
      #             _test(input, j, loop)
      #         end
      #       end).()
    end
  end

  defp check_split(a, b, input) do
    a = _morph(a, 1, [], 1, 1)
    a2 = _morph(a, 1, [], 1, 1)
    b = _morph(b, 1, [], 1, 1)
    b2 = _morph(b, 1, [], 1, 1)
    test = _morph(input, 1, [], 1, 1)
    test2 = _morph(test, 1, [], 1, 1)

    if a2 ++ b2 == test2 do
      {:ok, a, b}
    else
      {:no, test}
    end
  end

  def split(input) do
    input
    |> Enum.chunk_while(
      [],
      fn
        1, [2 | _] = acc when length(acc) > 1 ->
          {:cont, Enum.reverse(acc), [1]}

        3, [2 | _] = acc when length(acc) > 1 ->
          {:cont, Enum.reverse(acc), [3]}

        e, acc ->
          {:cont, [e | acc]}
      end,
      fn
        [] ->
          {:cont, []}

        acc ->
          {:cont, Enum.reverse(acc), []}
      end
    )
  end

  def chunk(input) do
    input
    |> Integer.digits()
    |> Enum.chunk_while(
      [],
      fn
        1, [2 | _] = acc ->
          {:cont, Enum.reverse(acc), [1]}

        3, [2 | _] = acc ->
          {:cont, Enum.reverse(acc), [3]}

        e, acc ->
          {:cont, [e | acc]}
      end,
      fn
        [] ->
          {:cont, []}

        acc ->
          {:cont, Enum.reverse(acc), []}
      end
    )
  end

  @r ~r/(\d)\1*/

  def look_and_say(input, n) do
    _look_and_say(input, 0, n)
  end

  defp _look_and_say(seq, i, n) when i == n, do: seq

  defp _look_and_say(seq, i, n) do
    Regex.scan(@r, seq)
    |> Enum.reduce([], fn [say, look], acc -> "#{acc}#{String.length(say)}#{look}" end)
    |> _look_and_say(i + 1, n)
  end

  def morph(input, i), do: _morph(Integer.digits(input), 1, [], 1, i)

  defp _morph([d | []], say, seq, i, loop) when i == loop,
    do: seq ++ Integer.digits(say) ++ Integer.digits(d)

  defp _morph([d | []], say, seq, i, loop),
    do: _morph(List.flatten([seq, say, d]), 1, [], i + 1, loop)

  defp _morph([d | rest], say, seq, i, loop) when hd(rest) == d do
    _morph(rest, say + 1, seq, i, loop)
  end

  defp _morph([d | rest], say, seq, i, loop) do
    _morph(rest, 1, seq ++ [say, d], i, loop)
  end
end
