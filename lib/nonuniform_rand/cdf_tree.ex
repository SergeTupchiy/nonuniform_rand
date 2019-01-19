defmodule NonuniformRand.CdfTree do

  @type probs_list :: %{required(any) => float()} | [{any(), float()}]
  @type gb_tree_node(k, v) :: :nil | {k, v, gb_tree_node(k, v), gb_tree_node(k, v)}
  
  @spec init_cdf_tree(probs_list()) :: gb_tree_node(float(), any())
  def init_cdf_tree([]), do: raise(ArgumentError, "Empty probabilities list")
  def init_cdf_tree(probs) when map_size(probs)==0 do
    raise(ArgumentError, "Empty probabilities map")
  end
  def init_cdf_tree(probs_list) do
    {_size, tree} = cdf(probs_list, [], 0)
    tree
  end

  @spec next_random(gb_tree_node(float(), any())) :: any()
  def next_random(tree) do
    random = :rand.uniform()
    lookup_smallest_gte(tree, nil, nil, random)
  end

  defp cdf([], acc, _cum_prob) do
    Enum.reverse(acc) |> :gb_trees.from_orddict()
  end

  defp cdf([{value, prob}|t], acc, cum_prob) do
      new_cum_prob = prob+cum_prob
      new_acc = [{new_cum_prob, value} | acc]
      cdf(t, new_acc, new_cum_prob)
  end

  defp cdf(weighted_list, acc, cum_prob) when is_map(weighted_list) do
    weighted_list
    |> Map.to_list()
    |> cdf(acc, cum_prob)
  end

  def lookup_smallest_gte({key, value, _smaller, _bigger},
	_prev_key, _prev_value, lookup_val) when lookup_val==key, do: value
  def lookup_smallest_gte({key, value, nil, _bigger},
	_prev_key, _prev_value, lookup_val) when lookup_val<key, do: value
  def lookup_smallest_gte({key, _value, _smaller, nil},
	_prev_key, prev_value, lookup_val) when lookup_val>key, do: prev_value
  def lookup_smallest_gte({key, value, smaller, _bigger},
	_prev_key, _prev_value, lookup_val) when lookup_val<key do
    lookup_smallest_gte(smaller, key, value, lookup_val)
  end
  def lookup_smallest_gte({key, value, _smaller, bigger},
	prev_key, prev_value, lookup_val) when lookup_val>key do
    {new_key, new_value} = cond do
      key > prev_key -> {key, value}
      true -> {prev_key, prev_value}
    end
    lookup_smallest_gte(bigger, new_key, new_value, lookup_val)
  end

end
