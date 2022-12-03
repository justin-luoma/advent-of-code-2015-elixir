defmodule AOC.Day22.Part2 do
  @boss %{
    :name => "boss",
    :hp => 51,
    :damage => 9,
    :armor => 0,
    :effects => []
  }

  @player %{
    :name => "player",
    :hp => 50,
    :armor => 0,
    :mana => 500,
    :effects => []
  }

  @spells [
    magic_missile: {:magic_missile, 53, damage: 4},
    drain: {:drain, 73, damage: 2, effect: {:self, :heal, 2}},
    shield: {:shield, 113, effect: {:self, :armor, 7, 6}},
    # 18 damage
    poison: {:poison, 173, effect: {:target, :damage, 3, 6}},
    recharge: {:recharge, 229, effect: {:self, :mana, 101, 5}}
  ]

  def player(), do: @player

  def boss(), do: @boss

  def spells(), do: Keyword.keys(@spells) |> Enum.shuffle()

  def example(actions) do
    turn(
      @player,
      @boss,
      actions,
      [],
      :player
    )
  end

  def receive_() do
    list = []

    receive do
      {min, spells} ->
        IO.inspect({min, spells}, limit: :infinity)
        [{min, spells} | list]
    after
      10000 -> nil
    end
  end

  def processes() do
    spells()
    |> Enum.map(fn spell ->
      Process.spawn(
        fn ->
          values = AOC.Day22.Part1.recur([spell], [])

          min =
            values
            |> Enum.min_by(fn {min, _} -> min end)

          send({:node, :node@subnets}, {min, values})
        end,
        [:monitor]
      )
    end)
  end

  def solve() do
    recur(spells(), [])
    |> IO.inspect()
    |> Enum.min_by(fn {min, _} -> min end)
  end

  def recur([], acc), do: acc

  def recur([h | t], acc) do
    val = _recur(turn(@player, @boss, [h], [], :player), 10000, [h])

    recur(t, [val | acc])
  end

  def _recur(:lose, min, _spells) do
    spell = get_spell(spells(), [])
    _recur(turn(@player, @boss, [spell], [], :player), min, [spell])
  end

  def _recur(:win, min, spells) do
    cost = total_cost(spells, 0)

    if cost < min do
      {cost, spells |> Enum.reverse()}
    else
      spell = get_spell(spells(), [])
      _recur(turn(@player, @boss, [spell], [], :player), min, [spell])
    end
  end

  def _recur({player, boss, active_effects}, min, spells) do
    if player[:hp] <= 1 do
      _recur(:lose, min, [])
    else
      spell =
        spells()
        |> get_spell(active_effects)

      _recur(turn(player, boss, [spell], active_effects, :player), min, [spell | spells])
    end
  end

  def get_spell([spell | _], active_effects) when length(active_effects) == 0, do: spell

  def get_spell([spell | spells], active_effects) do
    if Enum.member?(active_effects, spell) do
      get_spell(spells, active_effects)
    else
      spell
    end
  end

  def total_cost([], total), do: total

  def total_cost([spell | spells], total) do
    {_, cost, _} = @spells[spell]
    total_cost(spells, cost + total)
  end

  # def round(player, boss, actions) do

  # end

  # def _round({player, boss, active_effects}, [action | actions]) do
  #   _round(_turn(player, boss, action, active_effects, :player), actions)
  # end

  def turn(player, boss, [], active_effects, turn) when turn == :player do
    {player, boss, active_effects}
  end

  def turn(player, boss, [action | t], active_effects, turn) when turn == :player do
    player = Map.get_and_update!(player, :hp, fn hp -> {hp, hp - 1} end) |> elem(1)

    if player[:hp] <= 0 do
      :lose
    else
      {boss, active_effects} = tick_effects(boss, active_effects)
      {player, active_effects} = tick_effects(player, active_effects)
      # IO.inspect({player, active_effects}, label: :player, limit: :infinity)

      case check(player, boss) do
        :win ->
          :win

        :lose ->
          :lose

        false ->
          if not Enum.member?(active_effects, action) do
            case cast(player, boss, @spells[action]) do
              :not_enough_mana ->
                :lose

              {player, boss} ->
                turn(player, boss, t, active_effects, :boss)

              {player, boss, effect} ->
                turn(player, boss, t, [effect | active_effects], :boss)
            end
          else
            :cannot_cast
          end
      end
    end
  end

  def turn(player, boss, actions, active_effects, turn) when turn == :boss do
    {boss, active_effects} = tick_effects(boss, active_effects)
    {player, active_effects} = tick_effects(player, active_effects)
    # IO.inspect({player, active_effects}, label: :boss, limit: :infinity)

    case check(player, boss) do
      :win ->
        :win

      :lose ->
        :lose

      false ->
        player = damage(player, boss[:damage])

        if player[:hp] <= 0 do
          :lose
        else
          turn(player, boss, actions, active_effects, :player)
        end
    end
  end

  def check(player, boss) do
    # IO.inspect(player, label: :player, limit: :infinity)
    # IO.inspect(boss, label: :boss, limit: :infinity)

    cond do
      player[:hp] <= 0 ->
        :lose

      boss[:hp] <= 0 ->
        :win

      true ->
        false
    end
  end

  def tick_effects(entity, active_effects) do
    effects = entity[:effects]

    _tick_effects(effects, entity, active_effects)
  end

  defp _tick_effects([], entity, active_effects), do: {entity, active_effects}

  # armor remove
  defp _tick_effects([{name, effect, amt, timer} = e | t], entity, active_effects)
       when effect == :armor and timer == 1 do
    Map.get_and_update!(entity, :armor, fn armor -> {armor, armor - amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.delete(effects, e)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects(name, timer - 1, active_effects)) end).()
  end

  # armor status
  defp _tick_effects([{name, effect, amt, timer} | t], entity, active_effects)
       when effect == :armor do
    Map.get_and_update!(entity, :effects, fn effects ->
      i = Enum.find_index(effects, fn {n, _, _, _} -> name == n end)
      {effects, List.update_at(effects, i, fn _ -> {name, effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects(name, timer - 1, active_effects)) end).()
  end

  # damage remove
  defp _tick_effects([{name, effect, amt, timer} | t], entity, active_effects)
       when effect == :damage and timer == 0 do
    damage(entity, amt)
    |> Map.get_and_update!(:effects, fn effects ->
      i = Enum.find_index(effects, fn {n, _, _, _} -> name == n end)
      {effects, List.delete_at(effects, i)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects) end).()
  end

  # damage status
  defp _tick_effects([{name, effect, amt, timer} | t], entity, active_effects)
       when effect == :damage do
    damage(entity, amt)
    |> Map.get_and_update!(:effects, fn effects ->
      i = Enum.find_index(effects, fn {n, _, _, _} -> name == n end)
      {effects, List.update_at(effects, i, fn _ -> {name, effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects(name, timer - 1, active_effects)) end).()
  end

  # mana remove
  defp _tick_effects([{_name, effect, amt, timer} = e | t], entity, active_effects)
       when effect == :mana and timer == 0 do
    Map.get_and_update!(entity, :mana, fn mana -> {mana, mana + amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.delete(effects, e)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects) end).()
  end

  # mana status
  defp _tick_effects([{name, effect, amt, timer} | t], entity, active_effects)
       when effect == :mana do
    Map.get_and_update!(entity, :mana, fn mana -> {mana, mana + amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      i = Enum.find_index(effects, fn {n, _, _, _} -> name == n end)
      {effects, List.update_at(effects, i, fn _ -> {name, effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity, active_effects(name, timer - 1, active_effects)) end).()
  end

  def active_effects(name, timer, active_effects) when timer <= 0 do
    List.delete(active_effects, name)
  end

  def active_effects(_name, _timer, active_effects), do: active_effects

  def damage(entity, damage) do
    armor = entity[:armor]
    Map.get_and_update!(entity, :hp, fn hp -> {hp, hp - max(1, damage - armor)} end) |> elem(1)
  end

  def cast(caster, other, {_name, cost, [damage: damage]}) do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        other = Map.get_and_update!(other, :hp, fn hp -> {hp, hp - damage} end) |> elem(1)
        {caster, other}
    end
  end

  def cast(caster, other, {name, cost, [effect: {target, type, value, timer}]})
      when target == :self do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        caster = apply_effect(caster, name, type, value, timer)

        {caster, other, name}
    end
  end

  def cast(caster, other, {name, cost, [effect: {target, type, value, timer}]})
      when target == :target do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        other = apply_effect(other, name, type, value, timer)

        {caster, other, name}
    end
  end

  def cast(caster, other, {_name, cost, [damage: damage, effect: {:self, type, amount}]}) do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        other = apply_effect(other, :damage, damage)
        caster = apply_effect(caster, type, amount)

        {caster, other}
    end
  end

  defp _cast(caster, cost) do
    {mana, caster} = Map.get_and_update!(caster, :mana, fn val -> {val, val - cost} end)

    if cost > mana do
      :not_enough_mana
    else
      caster
    end
  end

  defp apply_effect(entity, type, value) when type == :damage do
    Map.get_and_update!(entity, :hp, fn hp -> {hp, hp - value} end) |> elem(1)
  end

  defp apply_effect(entity, type, value) when type == :heal do
    Map.get_and_update!(entity, :hp, fn hp -> {hp, hp + value} end) |> elem(1)
  end

  defp apply_effect(entity, name, type, value, timer) when type == :armor do
    Map.get_and_update!(entity, :armor, fn armor -> {armor, armor + value} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, [{name, type, value, timer} | effects] |> Enum.reverse()}
    end)
    |> elem(1)
  end

  defp apply_effect(entity, name, type, value, timer) do
    Map.get_and_update!(entity, :effects, fn effects ->
      {effects, [{name, type, value, timer} | effects] |> Enum.reverse()}
    end)
    |> elem(1)
  end
end
