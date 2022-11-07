defmodule AOC.Day22.Part1 do
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
    magic_missile: {53, damage: 4},
    drain: {73, damage: 2, effect: {:self, :heal, 2}},
    shield: {113, effect: {:self, :armor, 7, 6}},
    poison: {173, effect: {:target, :damage, 3, 6}},
    recharge: {229, effect: {:self, :mana, 101, 5}}
  ]

  def player(), do: @player

  def boss(), do: @boss

  def spells(), do: @spells

  def example() do
    actions = [:recharge, :shield, :drain, :poison, :magic_missile]

    turn(
      %{:hp => 10, :armor => 0, :mana => 250, :effects => []},
      %{:hp => 13, :damage => 8, :armor => 0, :effects => []},
      actions,
      :player
    )
  end

  def turn(_player, _boss, [], turn) when turn == :player, do: :end

  def turn(player, boss, [action | t], turn) when turn == :player do
    player = tick_effects(player)
    boss = tick_effects(boss)

    case check(player, boss) do
      :win ->
        :win

      :lose ->
        :lose

      false ->
        case cast(player, boss, @spells[action]) do
          :not_enough_mana ->
            :lose

          {player, boss} ->
            turn(player, boss, t, :boss)
        end
    end
  end

  def turn(player, boss, actions, turn) when turn == :boss do
    boss = tick_effects(boss)
    player = tick_effects(player)

    case check(player, boss) do
      :win ->
        :win

      :lose ->
        :lose

      false ->
        player = damage(player, boss[:damage])

        if player[:hp] <= 0 do
          :loss
        else
          turn(player, boss, actions, :player)
        end
    end
  end

  def check(player, boss) do
    IO.inspect(player, label: :player)
    IO.inspect(boss, label: :boss)

    cond do
      player[:hp] <= 0 ->
        :lose

      boss[:hp] <= 0 ->
        :win

      true ->
        false
    end
  end

  def tick_effects(entity) do
    effects = entity[:effects] |> Enum.with_index()

    _tick_effects(effects, entity)
  end

  defp _tick_effects([], entity), do: entity

  # armor apply
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity)
       when effect == :armor and timer == 6 do
    Map.get_and_update!(entity, :armor, fn armor -> {armor, armor + amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.update_at(effects, i, fn _ -> {effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # armor remove
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity)
       when effect == :armor and timer == 0 do
    Map.get_and_update!(entity, :armor, fn armor -> {armor, armor - amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.delete_at(effects, i)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # armor status
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity)
       when effect == :armor do
    Map.get_and_update!(entity, :effects, fn effects ->
      {effects, List.update_at(effects, i, fn _ -> {effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # damage remove
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity)
       when effect == :damage and timer == 0 do
    damage(entity, amt)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.delete_at(effects, i)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # damage status
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity) when effect == :damage do
    damage(entity, amt)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.update_at(effects, i, fn _ -> {effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # mana remove
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity)
       when effect == :mana and timer == 0 do
    Map.get_and_update!(entity, :mana, fn mana -> {mana, mana + amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.delete_at(effects, i)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  # mana status
  defp _tick_effects([{{effect, amt, timer}, i} | t], entity) when effect == :mana do
    Map.get_and_update!(entity, :mana, fn mana -> {mana, mana + amt} end)
    |> elem(1)
    |> Map.get_and_update!(:effects, fn effects ->
      {effects, List.update_at(effects, i, fn _ -> {effect, amt, timer - 1} end)}
    end)
    |> elem(1)
    |> (fn entity -> _tick_effects(t, entity) end).()
  end

  def damage(entity, damage) do
    armor = entity[:armor]
    Map.get_and_update!(entity, :hp, fn hp -> {hp, hp - max(1, damage - armor)} end) |> elem(1)
  end

  def cast(caster, other, {cost, [damage: damage]}) do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        other = Map.get_and_update!(other, :hp, fn hp -> {hp, hp - damage} end) |> elem(1)
        {caster, other}
    end
  end

  def cast(caster, other, {cost, [effect: {target, type, value, timer}]})
      when target == :self do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        caster = apply_effect(caster, type, value, timer)

        {caster, other}
    end
  end

  def cast(caster, other, {cost, [effect: {target, type, value, timer}]})
      when target == :target do
    case _cast(caster, cost) do
      :not_enough_mana ->
        :not_enough_mana

      caster ->
        other = apply_effect(other, type, value, timer)

        {caster, other}
    end
  end

  def cast(caster, other, {cost, [damage: damage, effect: {:self, type, amount}]}) do
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

  defp apply_effect(entity, type, value, timer) do
    Map.get_and_update!(entity, :effects, fn effects ->
      {effects, [{type, value, timer} | effects] |> Enum.reverse()}
    end)
    |> elem(1)
  end
end
