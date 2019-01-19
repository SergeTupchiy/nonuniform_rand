defmodule Profiling do

  require Profiling.Helper
  import Profiling.Helper
  import Profiling.PrettyTable, only: [print_table: 3]
  alias NonuniformRand

  @input_medium_data_list [
  {"Enum.all?/2", 0.0003559859},
  {"Enum.any?/2", 0.0005339789},
  {"Enum.at/3", 0.0001067958},
  {"Enum.chunk_by/2", 0.0001423944},
  {"Enum.chunk_every/2", 0.000177993},
  {"Enum.chunk_every/4", 0.0002135915},
  {"Enum.chunk_while/4",0.0002491901},
  {"Enum.concat/1", 0.0002847887},
  {"Enum.concat/2", 0.0003203873},
  {"Enum.count/1", 0.0003559859},
  {"Enum.count/2", 0.0003915845},
  {"Enum.dedup/1", 0.0004271831},
  {"Enum.dedup_by/2", 0.0004627817},
  {"Enum.drop/2", 0.0004983803},
  {"Enum.drop_every/2", 0.0005339789},
  {"Enum.drop_while/2", 0.0005695774},
  {"Enum.each/2", 0.000605176},
  {"Enum.empty?/1", 0.0006407746},
  {"Enum.fetch!/2", 0.0006763732},
  {"Enum.fetch/2", 0.0007119718},
  {"Enum.filter/2",0.0007475704},
  {"Enum.find/3", 0.000783169},
  {"Enum.find_index/2", 0.0008187676},
  {"Enum.find_value/3", 0.0008543662},
  {"Enum.flat_map/2", 0.0008899648},
  {"Enum.flat_map_reduce/3", 0.0009255633},
  {"Enum.group_by/3", 0.0009611619},
  {"Enum.intersperse/2", 0.0009967605},
  {"Enum.into/2", 0.0010323591},
  {"Enum.into/3", 0.0010679577},
  {"Enum.join/2", 0.0011035563},
  {"Enum.map/2", 0.0011391549},
  {"Enum.map_every/3", 0.0011747535},
  {"Enum.map_join/3", 0.0012103521},
  {"Enum.map_reduce/3", 0.0012459507},
  {"Enum.max/2", 0.0012815493},
  {"Enum.max_by/3", 0.0013171478},
  {"Enum.member?/2", 0.0013527464},
  {"Enum.min/2", 0.001388345},
  {"Enum.min_by/3", 0.0014239436},
  {"Enum.min_max/2", 0.0014595422},
  {"Enum.min_max_by/3",0.0014951408},
  {"Enum.random/1", 0.0015307394},
  {"Enum.reduce/2", 0.001566338},
  {"Enum.reduce/3", 0.0016019366},
  {"Enum.reduce_while/3", 0.0016375352},
  {"Enum.reject/2", 0.0016731337},
  {"Enum.reverse/1", 0.0017087323},
  {"Enum.reverse/2",0.0017443309},
  {"Enum.reverse_slice/3", 0.0017799295},
  {"Enum.scan/2", 0.0018155281},
  {"Enum.scan/3", 0.0018511267},
  {"Enum.shuffle/1", 0.0018867253},
  {"Enum.slice/2", 0.0019223239},
  {"Enum.slice/3", 0.0019579225},
  {"Enum.sort/1",0.0019935211},
  {"Enum.sort/2", 0.0020291196},
  {"Enum.sort_by/3", 0.0020647182},
  {"Enum.split/2", 0.0021003168},
  {"Enum.split_while/2", 0.0021359154},
  {"Enum.split_with/2", 0.002171514},
  {"Enum.sum/1", 0.0022071126},
  {"Enum.take/2", 0.0022427112},
  {"Enum.take_every/2", 0.0022783098},
  {"Enum.take_random/2", 0.0023139084},
  {"Enum.take_while/2", 0.002349507},
  {"Enum.to_list/1", 0.0023851055},
  {"Enum.uniq/1", 0.0024207041},
  {"Enum.uniq_by/2", 0.0024563027},
  {"Enum.unzip/1", 0.0024919013},
  {"Enum.with_index/2", 0.0025274999},
  {"Enum.zip/1", 0.0025630985},
  {"Enum.zip/2", 0.0025986971},
  {"Kernel.!/1", 0.0026342957},
  {"Kernel.!=/2", 0.0026698943},
  {"Kernel.!==/2", 0.0027054929},
  {"Kernel.&&/2", 0.0027410915},
  {"Kernel.*/2", 0.00277669},
  {"Kernel.++/2", 0.0028122886},
  {"Kernel.+/1", 0.0028478872},
  {"Kernel.+/2", 0.0028834858},
  {"Kernel.--/2", 0.0029190844},
  {"Kernel.-/1", 0.002954683},
  {"Kernel.-/2", 0.0029902816},
  {"Kernel.../2", 0.0030258802},
  {"Kernel.//2", 0.0030614788},
  {"Kernel.</2", 0.0030970774},
  {"Kernel.<=/2", 0.0031326759},
  {"Kernel.<>/2", 0.0031682745},
  {"Kernel.==/2", 0.0032038731},
  {"Kernel.===/2", 0.0032394717},
  {"Kernel.=~/2", 0.0032750703},
  {"Kernel.>/2", 0.0033106689},
  {"Kernel.>=/2", 0.0033462675},
  {"Kernel.@/1", 0.0033818661},
  {"Kernel.abs/1", 0.0034174647},
  {"Kernel.alias!/1", 0.0034530633},
  {"Kernel.and/2", 0.0034886618},
  {"Kernel.apply/2", 0.0035242604},
  {"Kernel.apply/3", 0.003559859},
  {"Kernel.binary_part/3", 0.0035954576},
  {"Kernel.binding/1", 0.0036310562},
  {"Kernel.bit_size/1", 0.0036666548},
  {"Kernel.byte_size/1", 0.0037022534},
  {"Kernel.def/2", 0.0355985903},
  {"Kernel.defdelegate/2", 0.0037734506},
  {"Kernel.defexception/1", 0.0038090492},
  {"Kernel.defguard/1", 0.0038446478},
  {"Kernel.defguardp/1", 0.0038802463},
  {"Kernel.defimpl/3", 0.0039158449},
  {"Kernel.defmacro/2", 0.0039514435},
  {"Kernel.defmacrop/2", 0.0039870421},
  {"Kernel.defmodule/2", 0.0040226407},
  {"Kernel.defoverridable/1", 0.0040582393},
  {"Kernel.defp/2", 0.0040938379},
  {"Kernel.defprotocol/2", 0.0041294365},
  {"Kernel.defstruct/1", 0.0041650351},
  {"Kernel.destructure/2", 0.0042006337},
  {"Kernel.div/2", 0.0042362322},
  {"Kernel.elem/2", 0.0042718308},
  {"Kernel.exit/1", 0.0043074294},
  {"Kernel.function_exported?/3", 0.004343028},
  {"Kernel.get_and_update_in/2", 0.0043786266},
  {"Kernel.get_and_update_in/3", 0.0044142252},
  {"Kernel.get_in/2", 0.0044498238},
  {"Kernel.hd/1", 0.0044854224},
  {"Kernel.if/2", 0.2491901321},
  {"Kernel.in/2", 0.0045566196},
  {"Kernel.inspect/2", 0.0045922181},
  {"Kernel.is_atom/1", 0.0046278167},
  {"Kernel.is_binary/1", 0.0046634153},
  {"Kernel.is_bitstring/1", 0.0046990139},
  {"Kernel.is_boolean/1", 0.0047346125},
  {"Kernel.is_float/1", 0.0047702111},
  {"Kernel.is_function/1", 0.0048058097},
  {"Kernel.is_function/2", 0.0048414083},
  {"Kernel.is_integer/1", 0.0048770069},
  {"Kernel.is_list/1", 0.0049126055},
  {"Kernel.is_map/1", 0.0049482041},
  {"Kernel.is_nil/1", 0.0049838026},
  {"Kernel.is_number/1", 0.0050194012},
  {"Kernel.is_pid/1", 0.0050549998},
  {"Kernel.is_port/1", 0.0050905984},
  {"Kernel.is_reference/1", 0.005126197},
  {"Kernel.is_tuple/1",0.0051617956},
  {"Kernel.length/1", 0.0051973942},
  {"Kernel.macro_exported?/3", 0.0052329928},
  {"Kernel.make_ref/0", 0.0052685914},
  {"Kernel.map_size/1", 0.00530419},
  {"Kernel.match?/2", 0.0053397885},
  {"Kernel.max/2", 0.0053753871},
  {"Kernel.min/2",0.0054109857},
  {"Kernel.node/0", 0.0054465843},
  {"Kernel.node/1", 0.0054821829},
  {"Kernel.not/1", 0.0055177815},
  {"Kernel.or/2", 0.0055533801},
  {"Kernel.pop_in/1", 0.0055889787},
  {"Kernel.pop_in/2", 0.0056245773},
  {"Kernel.put_elem/3",0.0056601759},
  {"Kernel.put_in/2", 0.0056957744},
  {"Kernel.put_in/3", 0.005731373},
  {"Kernel.raise/1", 0.0057669716},
  {"Kernel.raise/2", 0.0058025702},
  {"Kernel.rem/2", 0.0058381688},
  {"Kernel.reraise/2", 0.0058737674},
  {"Kernel.reraise/3",0.005909366},
  {"Kernel.round/1", 0.0059449646},
  {"Kernel.self/0", 0.0059805632},
  {"Kernel.send/2", 0.0060161618},
  {"Kernel.sigil_C/2", 0.0060517604},
  {"Kernel.sigil_D/2", 0.0060873589},
  {"Kernel.sigil_N/2", 0.0061229575},
  {"Kernel.sigil_R/2",0.0061585561},
  {"Kernel.sigil_S/2", 0.0061941547},
  {"Kernel.sigil_T/2", 0.0062297533},
  {"Kernel.sigil_W/2", 0.0062653519},
  {"Kernel.sigil_c/2", 0.0063009505},
  {"Kernel.sigil_r/2", 0.0063365491},
  {"Kernel.sigil_s/2", 0.0063721477},
  {"Kernel.sigil_w/2",0.0064077463},
  {"Kernel.spawn/1", 0.0064433448},
  {"Kernel.spawn/3", 0.0064789434},
  {"Kernel.spawn_link/1", 0.006514542},
  {"Kernel.spawn_link/3", 0.0065501406},
  {"Kernel.spawn_monitor/1", 0.0065857392},
  {"Kernel.spawn_monitor/3", 0.0066213378},
  {"Kernel.struct!/2",0.0066569364},
  {"Kernel.struct/2", 0.006692535},
  {"Kernel.throw/1", 0.0067281336},
  {"Kernel.tl/1", 0.0067637322},
  {"Kernel.to_charlist/1", 0.0067993307},
  {"Kernel.to_string/1", 0.0068349293},
  {"Kernel.trunc/1", 0.0068705279},
  {"Kernel.tuple_size/1",0.0069061265},
  {"Kernel.unless/2", 0.0069417251},
  {"Kernel.update_in/2", 0.0069773237},
  {"Kernel.update_in/3", 0.0070129223},
  {"Kernel.use/2", 0.0070485209},
  {"Kernel.var!/2", 0.0070841195},
  {"Kernel.|>/2", 0.0071197181},
  {"Kernel.||/2", 0.0071553166}
]

  @input_small_data_list [
    {"low_prob", 0.05},
    {"medium_prob", 0.35},
    {"high_prob", 0.6}
  ]

  def run() do
    # small input data
    calculate_and_print_results(@input_small_data_list, "small data input")

    # Medium input data
    calculate_and_print_results(@input_medium_data_list, "medium data input")

    # Large input data
    get_lines_from_file("weighted_values.dat")
    |> parse_lines([])
    |> calculate_and_print_results("large data input")
  end

  def calculate_and_print_results(input_data, input_title) do
    alias_generator =
      exec_with_time "Alias initialization, #{input_title}", :nanoseconds do
        NonuniformRand.make_generator(input_data, :alias)
      end
    cdf_generator =
      exec_with_time "CDF initialization, #{input_title}", :nanoseconds do
        NonuniformRand.make_generator(input_data, :cdf)
      end
    alias_generated_values =
      exec_with_time "Alias #{input_title}, generating 1_000_000 randoms" do
        for _n <- 0.. 1_000_000, do: alias_generator.(:next_rand)
      end
    cdf_generated_values =
      exec_with_time "CDF #{input_title}, generating 1_000_000 randoms" do
        for _n <- 0.. 1_000_000, do: cdf_generator.(:next_rand)
    end
    sorter = fn({_, first_prob}, {_, second_prob}) -> first_prob>second_prob end
    alias_rel_freqs = get_relative_freqs(alias_generated_values) |> Enum.sort(sorter)
    cdf_rel_freqs = get_relative_freqs(cdf_generated_values) |> Enum.sort(sorter)
    IO.puts("#{input_title} generated values accuracy report:")
    print_table({Enum.sort(input_data, sorter), alias_rel_freqs, cdf_rel_freqs},
      {"Input probabilities", "CDF relative freqs", "Alias relative freqs"}, 100)
  end

end



