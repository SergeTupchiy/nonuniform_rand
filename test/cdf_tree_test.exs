defmodule CdfTreeTest do
  use ExUnit.Case
  import NonuniformRand.CdfTree

  @probs  [
    {1, 0.3},
    {2, 0.3},
    {3, 0.1},
    {4, 0.1},
    {5, 0.06},
    {6, 0.04},
    {7, 0.03},
    {8, 0.02},
    {9, 0.05}
  ]

# generated CDF tree:
#  {0.8599999999999999, 5,
#    {0.7, 3, {0.6, 2, {0.3, 1, nil, nil}, nil}, {0.7999999999999# 999, 4, nil, nil}},
#    {0.95, 8, {0.9299999999999999, 7, {0.8999999999999999, 6, nil, nil}, nil},
#      {1.0, 9, nil, nil}}}
  test "init from list and map" do
    tree_from_list = init_cdf_tree(@probs)
    tree_from_map = Enum.into(@probs, %{}) |> init_cdf_tree()
    assert tree_from_list == tree_from_map
  end  
  
  test "lookup smallest gte" do
    tree = init_cdf_tree(@probs)
    assert lookup_smallest_gte(tree, nil, nil, 0.21) == 1
    assert lookup_smallest_gte(tree, nil, nil, 0.54) == 2
    assert lookup_smallest_gte(tree, nil, nil, 0.63) == 3
    assert lookup_smallest_gte(tree, nil, nil, 0.79) == 4
    assert lookup_smallest_gte(tree, nil, nil, 0.80) == 5
    assert lookup_smallest_gte(tree, nil, nil, 0.86) == 6
    assert lookup_smallest_gte(tree, nil, nil, 0.90) == 7 
    assert lookup_smallest_gte(tree, nil, nil, 0.93) == 8
    assert lookup_smallest_gte(tree, nil, nil, 0.96) == 9
  end
end
