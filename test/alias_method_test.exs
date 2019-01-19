defmodule AliasMethodTest do
  use ExUnit.Case
  import NonuniformRand.AliasMethod

  @input_small_data [
    low_prob: 0.05,
    medium_prob: 0.35,
    high_prob: 0.6
  ]

  @etalon_tables {
    %{0 => {:high_prob, 1},
      1 => {:low_prob, 0.15000000000000002},
      2 => {:medium_prob, 0.19999999999999996}
     },
    %{1 => :medium_prob, 2 => :high_prob}
  }

  test "init alias tables" do
    tables = Enum.sort(@input_small_data) |> init_prob_alias_tables
    tables_from_map = Enum.into(@input_small_data, %{})
                      |> Enum.sort()
                      |> init_prob_alias_tables()
    assert tables_from_map == tables
    assert tables == @etalon_tables
  end
end
