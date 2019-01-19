defmodule NonuniformRand do

  alias NonuniformRand.AliasMethod
  alias NonuniformRand.CdfTree

  @type probs_list :: %{required(any) => float()} | [{any(), float()}]

  @spec make_generator(probs_list(), :alias | :cdf) :: any()
  def make_generator(probs_list, :alias) do
    prob_table = AliasMethod.init_prob_alias_tables(probs_list)
    fn :next_rand -> AliasMethod.next_random(prob_table) end
  end
  def make_generator(probs_list, :cdf) do
    tree = CdfTree.init_cdf_tree(probs_list)
    fn :next_rand -> CdfTree.next_random(tree) end
  end

end
