defmodule NonuniformRand.AliasMethod do

  @moduledoc """
  Implementation is based on the following sources:
  http://www.keithschwarz.com/interesting/code/?dir=alias-method
  http://www.keithschwarz.com/darts-dice-coins/
  """

  @type probs_list :: %{required(any) => float()} | [{any(), float()}]
  @type alias_tables :: {%{non_neg_integer() => {any(), number()}},
			 %{non_neg_integer() => any()}}
						   
  @spec init_prob_alias_tables(probs_list()) :: alias_tables() 
  def init_prob_alias_tables([]), do: raise(ArgumentError, "Empty probabilities list")
  def init_prob_alias_tables(probs) when map_size(probs)==0 do
    raise(ArgumentError, "Empty probabilities map")
  end
  def init_prob_alias_tables(probs_list) do
    size = get_size(probs_list)
    avg = 1.0 / size
    rekeyed_probs = rekey_map(probs_list)
    split_to_small_large(rekeyed_probs, avg)
    |> fill_prob_alias_tables(%{}, %{}, rekeyed_probs, avg, size)
  end
  
  @spec next_random(alias_tables()) :: any()
  def next_random({prob_table, aliases}) do
    column = Enum.random(0..map_size(prob_table)-1)
    {val, prob} = Map.get(prob_table, column)
    coin_toss = :rand.uniform() < prob
    case coin_toss do
      true -> val
      false -> Map.get(aliases, column)
    end
  end

  defp get_size(collection) when is_map(collection), do: map_size(collection)
  defp get_size(collection) when is_list(collection), do: length(collection)

  defp rekey_map(probs_list) do
    {acc_map, _index} = Enum.reduce(probs_list, {%{}, 0}, fn ({val, prob}, {acc_map, index}) ->
       {Map.put(acc_map, index, {val, prob}), index+1}
    end)
    acc_map
  end

  defp split_to_small_large(rekeyed_probs, avg) do
    Enum.reduce(rekeyed_probs, {[], []}, fn ({index, {_val, prob}}, {small, large}) ->
      if prob >= avg do
        {small, [index | large]}
      else
        {[index | small], large}
      end
    end)
  end

  defp fill_prob_alias_tables({[], large}, prob, aliases, orig_prob, _avg, _size) do
    final_prob = clear_rem_list(large, prob, orig_prob)
    {final_prob, aliases}
  end

  defp fill_prob_alias_tables({small, []}, prob, aliases, orig_prob, _avg, _size) do
    final_prob = clear_rem_list(small, prob, orig_prob)
    {final_prob, aliases}
  end

  defp fill_prob_alias_tables({[small | rem_small], [large | rem_large]},
	prob, aliases, orig_prob, avg, size) do
    {large_val, prob_large} = Map.get(orig_prob, large)
    {small_val, prob_small} = Map.get(orig_prob, small)
    new_prob = Map.put(prob, small, {small_val, prob_small * size})
    new_alias = Map.put(aliases, small, large_val)
    rem_prob_large = (prob_large + prob_small) - avg
    new_orig_prob = Map.put(orig_prob, large, {large_val, rem_prob_large})
    if rem_prob_large >= avg do
      fill_prob_alias_tables({rem_small, [large | rem_large]},
	new_prob, new_alias, new_orig_prob, avg, size)
    else
	fill_prob_alias_tables({[large | rem_small], rem_large},
	  new_prob, new_alias, new_orig_prob, avg, size)
    end
  end

  def clear_rem_list([], prob_table, _orig_prob), do: prob_table

  def clear_rem_list([small_or_large | t], prob_table, orig_prob) do
    {val, _prob} = Map.get(orig_prob, small_or_large)
    new_prob_table = Map.put(prob_table, small_or_large, {val, 1})
    clear_rem_list(t, new_prob_table, orig_prob)
  end
end
