defmodule AOC.Day7.Part2 do
  import Bitwise

  def parse_instructions() do
    circuits =
      "input/day7"
      |> File.stream!()
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split/1)
      |> Enum.map(&parse/1)
      |> Enum.reduce(%{}, fn ins, circuit -> Map.put(circuit, elem(ins, 0), elem(ins, 1)) end)

    # IO.inspect(circuits)
    read_wire(circuits["a"], circuits)
  end

  def read_wire(signal, _circuit) when is_integer(signal) do
    # IO.inspect(signal, label: :signal)
    signal
  end

  def read_wire({:wire, wire}, circuit) do
    # IO.inspect(circuit[wire], label: :wire)
    read_wire(circuit[wire], circuit)
  end

  def read_wire({:and, signal1, signal2}, circuit) when is_integer(signal1) do
    # IO.inspect({signal1, signal2}, label: :andI)
    signal1 &&& read_wire(circuit[signal2], circuit)
  end

  def read_wire({:and, signal1, signal2}, circuit) do
    # IO.inspect({signal1, signal2}, label: :and)
    read_wire(circuit[signal1], circuit) &&& read_wire(circuit[signal2], circuit)
  end

  def read_wire({:or, signal1, signal2}, circuit) do
    # IO.inspect({signal1, signal2}, label: :or)
    read_wire(circuit[signal1], circuit) ||| read_wire(circuit[signal2], circuit)
  end

  def read_wire({:lshift, signal1, signal2}, circuit) do
    # IO.inspect({signal1, signal2}, label: :lshift)
    read_wire(circuit[signal1], circuit) <<< signal2
  end

  def read_wire({:rshift, signal1, signal2}, circuit) do
    # IO.inspect({signal1, signal2}, label: :rshift)
    read_wire(circuit[signal1], circuit) >>> signal2
  end

  def read_wire({:not, signal}, circuit) do
    # IO.inspect(signal, label: :not)
    bnot(read_wire(circuit[signal], circuit)) &&& 0xffff
  end

  def parse([command, "->", wire]) do
    case Integer.parse(command) do
      {signal, _} ->
        {wire, signal}

      :error ->
        {wire, {:wire, command}}
    end
  end

  def parse([signal1, "AND", signal2, "->", wire]) do
    signal1 =
      case Integer.parse(signal1) do
        {parsed, _} ->
          parsed

        :error ->
          signal1
      end

    {wire, {:and, signal1, signal2}}
  end

  def parse([signal1, "OR", signal2, "->", wire]) do
    {wire, {:or, signal1, signal2}}
  end

  def parse([signal1, "LSHIFT", signal2, "->", wire]) do
    {wire, {:lshift, signal1, elem(Integer.parse(signal2), 0)}}
  end

  def parse([signal1, "RSHIFT", signal2, "->", wire]) do
    {wire, {:rshift, signal1, elem(Integer.parse(signal2), 0)}}
  end

  def parse(["NOT", signal, "->", wire]) do
    {wire, {:not, signal}}
  end
end
