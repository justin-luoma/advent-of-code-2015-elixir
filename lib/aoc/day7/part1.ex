defmodule AOC.Day7.Part1 do
  import Bitwise

  def parse_instructions() do
    "input/day7"
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.split/1)
    |> Enum.map(&parse/1)
    |> process([], %{"b" => 956})
  end

  def process([], [], circuit), do: circuit

  def process([], queue, circuit), do: finish_queue(queue, circuit)

  def process([ins | rest], queue, circuit) do
    {queue, circuit} = process_queue(queue, [], circuit)

    if ready?(ins, circuit) do
      process(rest, queue, run_circuit(ins, circuit))
    else
      process(rest, queue ++ [ins], circuit)
    end
  end

  defp process_queue([], queue, circuit), do: {queue, circuit}

  defp process_queue([ins | rest], not_ready, circuit) do
    if ready?(ins, circuit) do
      process_queue(rest, not_ready, run_circuit(ins, circuit))
    else
      process_queue(rest, not_ready ++ [ins], circuit)
    end
  end

  defp finish_queue([], circuit), do: circuit

  defp finish_queue([ins | rest], circuit) do
    if ready?(ins, circuit) do
      finish_queue(rest, run_circuit(ins, circuit))
    else
      finish_queue(rest ++ [ins], circuit)
    end
  end

  defp ready?({:set, {signal, _}}, circuit) do
    case Integer.parse(signal) do
      :error ->
        if Map.has_key?(circuit, signal) do
          true
        else
          false
        end

      _ ->
        true
    end
  end

  defp ready?({:and, {signal1, signal2, _}}, circuit) do
    case Integer.parse(signal1) do
      :error ->
        if Map.has_key?(circuit, signal1) do
          case Integer.parse(signal2) do
            :error ->
              if Map.has_key?(circuit, signal2) do
                true
              else
                false
              end

            _ ->
              true
          end
        else
          false
        end

      _ ->
        case Integer.parse(signal2) do
          :error ->
            if Map.has_key?(circuit, signal2) do
              true
            else
              false
            end

          _ ->
            true
        end
    end
  end

  defp ready?({:or, {signal1, signal2, _}}, circuit) do
    case Integer.parse(signal1) do
      :error ->
        if Map.has_key?(circuit, signal1) do
          case Integer.parse(signal2) do
            :error ->
              if Map.has_key?(circuit, signal2) do
                true
              else
                false
              end

            _ ->
              true
          end
        else
          false
        end

      _ ->
        case Integer.parse(signal2) do
          :error ->
            if Map.has_key?(circuit, signal2) do
              true
            else
              false
            end

          _ ->
            true
        end
    end
  end

  defp ready?({:not, {signal, _}}, circuit) do
    case Integer.parse(signal) do
      :error ->
        if Map.has_key?(circuit, signal) do
          true
        else
          false
        end

      _ ->
        true
    end
  end

  defp ready?({:rshift, {signal, _, _}}, circuit) do
    case Integer.parse(signal) do
      :error ->
        if Map.has_key?(circuit, signal) do
          true
        else
          false
        end

      _ ->
        true
    end
  end

  defp ready?({:lshift, {signal, _, _}}, circuit) do
    case Integer.parse(signal) do
      :error ->
        if Map.has_key?(circuit, signal) do
          true
        else
          false
        end

      _ ->
        true
    end
  end

  def parse([val, "->", signal_wire]) do
    {:set, {val, signal_wire}}
  end

  def parse([wire1, "AND", wire2, "->", signal_wire]) do
    {:and, {wire1, wire2, signal_wire}}
  end

  def parse([wire1, "OR", wire2, "->", signal_wire]) do
    {:or, {wire1, wire2, signal_wire}}
  end

  def parse([wire1, "LSHIFT", val, "->", signal_wire]) do
    {:lshift, {wire1, val, signal_wire}}
  end

  def parse([wire1, "RSHIFT", val, "->", signal_wire]) do
    {:rshift, {wire1, val, signal_wire}}
  end

  def parse(["NOT", wire, "->", signal_wire]) do
    {:not, {wire, signal_wire}}
  end

  def run_circuit({:set, {signal, wire}}, circuit) do
    case Integer.parse(signal) do
      {val, _} ->
        Map.update(circuit, wire, val, fn _ -> val end)

      :error ->
        signal = circuit[signal]
        Map.update(circuit, wire, signal, fn _ -> signal end)
    end
  end

  def run_circuit({:and, {signal1, signal2, wire}}, circuit) do
    case Integer.parse(signal1) do
      {signal, _} ->
        val = signal &&& circuit[signal2]
        Map.update(circuit, wire, val, fn _ -> val end)

      :error ->
        val = circuit[signal1] &&& circuit[signal2]
        Map.update(circuit, wire, val, fn _ -> val end)
    end
  end

  def run_circuit({:or, {signal1, signal2, wire}}, circuit) do
    val = circuit[signal1] ||| circuit[signal2]
    Map.update(circuit, wire, val, fn _ -> val end)
  end

  def run_circuit({:lshift, {signal, val, wire}}, circuit) do
    val = circuit[signal] <<< elem(Integer.parse(val), 0)
    Map.update(circuit, wire, val, fn _ -> val end)
  end

  def run_circuit({:rshift, {signal, val, wire}}, circuit) do
    val = circuit[signal] >>> elem(Integer.parse(val), 0)
    Map.update(circuit, wire, val, fn _ -> val end)
  end

  def run_circuit({:not, {signal, wire}}, circuit) do
    val = bnot(circuit[signal]) &&& 0xffff
    Map.update(circuit, wire, val, fn _ -> val end)
  end
end
