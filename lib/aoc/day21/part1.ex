defmodule AOC.Day21.Part1 do
  @not [
      93,
      [:longsword, :splintmail],
      87,
      [:greataxe, :leather],
      91,
      [:longsword, :chainmail, :"defense +1"]
    ]

  @boss %{
    :hp => 104,
    :damage => 8,
    :armor => 1
  }

  @player %{
    :hp => 100,
    :damage => 0,
    :armor => 0
  }

  # {cost, damage, armor}
  @weapons %{
    :dagger => {8, 4, 0},
    :shortsword => {10, 5, 0},
    :warhammer => {25, 6, 0},
    :longsword => {40, 7, 0},
    :greataxe => {74, 8, 0}
  }

  @armor %{
    :leather => {13, 0, 1},
    :chainmail => {31, 0, 2},
    :splintmail => {53, 0, 3},
    :bandedmail => {75, 0, 4},
    :platemail => {102, 0, 5}
  }

  @rings %{
    :"damage +1" => {25, 1, 0},
    :"damage +2" => {50, 2, 0},
    :"damage +3" => {100, 3, 0},
    :"defense +1" => {20, 0, 1},
    :"defense +2" => {40, 0, 2},
    :"defense +3" => {80, 0, 3}
  }

  def player(), do: @player

  def boss(), do: @boss

  def solve() do
    player = %{
      @player
      | # @player | :damage => 7, :armor => 3
        :damage => (@weapons[:longsword] |> elem(1)) + (@rings[:"damage +1"] |> elem(1)),
        :armor => (@armor[:leather] |> elem(2))
    }

    # + (@rings[:"damage +1"] |> elem(1))

    # IO.inspect(player, label: :player)

    _fight(player, @boss)
  end

  # {armor, damage}
  def part2() do
    wins = [
      {0, 9},
      {1, 8},
      {2, 8},
      {3, 7},
      {4, 6}
    ]

    player = %{
      @player
      | # @player | :damage => 7, :armor => 3
        :damage => (@weapons[:dagger] |> elem(1)) + (@rings[:"damage +3"] |> elem(1)),
        :armor => (@rings[:"defense +2"] |> elem(2))
    }

    _fight(player, @boss)
    
  end

  def search(armor, damage) when damage > 20, do: search(armor + 1, 4)

  def search(armor, damage) do
    player = %{
      @player
      | :armor => armor, :damage => damage
    }

    if _fight(player, @boss) == :win do
      {armor, damage}
    else
      search(armor, damage + 1)
    end
  end

  def fight() do
    _fight(@player, @boss)
  end

  defp _fight(player, boss) do
    # IO.inspect({player, boss})
    boss = do_damage(boss, player[:damage])
    # IO.inspect(hp)

    if boss[:hp] <= 0 do
      :win
    else
      player = do_damage(player, boss[:damage])

      if player[:hp] <= 0 do
        :lose
      else
        _fight(player, boss)
      end
    end

    # _fight(player, boss)
  end

  def do_damage(entity, damage) do
    damage = max(damage - entity[:armor], 1)

    Map.get_and_update!(entity, :hp, &{&1, &1 - damage})
    |> elem(1)
  end
end
