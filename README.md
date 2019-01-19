# NonuniformRand

NonuniformRand is an Elixir library that provides the ability to generate random values (samples) 
from the given discrete distribution (represented as a list/map of values and their probabilities).
Two algorithms are implemented:

 * alias method (implementation is based on the decent article by Keith Schwarz that you can find at: 
   http://www.keithschwarz.com/darts-dice-coins/).
   This algorithm is aimed at sampling a value at a constant time O(1).
 * simple method that builds a binary search tree from the distribution's cumulative density function(CDF) and uses it for sampling random values.
   The complexity, therefore, is O(log n).
	  
Both algorithms require initialization (see details in Examples section below).

## Usage

Add nonuniform_random as a dependency in your  mix.exs:

```
{:nonuniform_rand, git: "https://github.com/sergetupchiy/nonuniform_rand.git", tag: "v0.1.0"}
```


Usage example:

```
alias NonuniformRand 
probs = [high_prob: 0.6, medium_prob: 0.3, low_prob: 0.096, very_low_prob: 0.04]
alias_gen = NonuniformRand.make_generator(probs, :alias)
cdf_gen = NonuniformRand.make_generator(probs, :cdf)
cdf_gen.(:next_rand)
alias_gen.(:next_rand)
```


If you don't like rather weird idea of anonymous function calls with :next_rand atom as an argument, you can initialize necessary algorithm and use it directly:

```
probs = [high_prob: 0.6, medium_prob: 0.3, low_prob: 0.096, very_low_prob: 0.04]
alias NonuniformRand.CdfTree
cdf_tree = CdfTree.init_cdf_tree(probs)
CdfTree.next_random(cdf_tree)
alias NonuniformRand.AliasMethod
alias_tables = AliasMethod.init_prob_alias_tables(probs)
AliasMethod.next_random(alias_tables) 
```

## Proving that it actually works...
The repository includes nested repository with some profiling of the both algorithms and simple verification that generated values do conform to the original distribution,  you can run it as follows:

```
$ cd examples/profiling
$ mix run -e 'Profiling.run'
```

The output will look something like this:

```
Task "Alias initialization, small data input" executed in: 7048 nanoseconds
Task "CDF initialization, small data input" executed in: 4147 nanoseconds
Task "Alias small data input, generating 1_000_000 randoms" executed in: 771 milliseconds
Task "CDF small data input, generating 1_000_000 randoms" executed in: 317 milliseconds
small data input generated values accuracy report:
 -------------------------------------------------------------------------------------------------------
 | "Input probabilities" | "CDF relative freqs"                 | "Alias relative freqs"               | 
 -------------------------------------------------------------------------------------------------------
 | {"high_prob", 0.6}    | {"high_prob", 0.5992854007145992}    | {"high_prob", 0.6003303996696003}    | 
 | {"medium_prob", 0.35} | {"medium_prob", 0.35063464936535066} | {"medium_prob", 0.35016664983335016} | 
 | {"low_prob", 0.05}    | {"low_prob", 0.05007994992005008}    | {"low_prob", 0.0495029504970495}     | 
 -------------------------------------------------------------------------------------------------------
Task "Alias initialization, large data input" executed in: 10864048 nanoseconds
Task "CDF initialization, large data input" executed in: 1996765 nanoseconds
Task "Alias large data input, generating 1_000_000 randoms" executed in: 914 milliseconds
Task "CDF large data input, generating 1_000_000 randoms" executed in: 644 milliseconds
large data input generated values accuracy report:
....

```

