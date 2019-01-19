defmodule Profiling.PrettyTable do

  def print_table(data_columns, headers, rows_limit \\ :infinity)
  when tuple_size(data_columns) == tuple_size(data_columns) do
    columns_widths = prepare_and_add_widths(data_columns, headers)
    {max_rows, truncated?} = get_max_rows(columns_widths, rows_limit)
    line = get_line_str(columns_widths)
    IO.puts(line)    
    header = get_row_str(columns_widths, 0)
    IO.puts(header)
    IO.puts(line)
    Enum.each(1..max_rows-1, fn n ->
      row = get_row_str(columns_widths, n)
      IO.puts(row)
    end)
    if truncated?, do: IO.puts( " | ..." <> String.duplicate(" ", String.length(line)-7) <> "|")
    IO.puts(line)
  end

  def get_row_str(columns_widths, row_n) do
    Enum.reduce(columns_widths, " | ", fn {column, width}, acc ->
      val = try do
	      elem(column, row_n)
	    rescue
	      ArgumentError -> "(empty)"
	    end
      indent = String.duplicate(" ", width - String.length(val))
      acc <> "#{val}#{indent} | "
    end)
  end  

  def get_line_str(columns_widths) do
    Enum.reduce(columns_widths, " ",
      fn {_column, width}, acc -> acc <> String.duplicate("-", width+3) end) <> "-"
  end  

  def prepare_and_add_widths(data_columns, headers) do
    for n <- 0..tuple_size(headers)-1 do
      header_column = [elem(headers, n) | elem(data_columns, n)]
      {column_str, width} = Enum.map_reduce(header_column, 0, fn cell, max_len ->
	cell_str = inspect(cell)
	l = String.length(cell_str)
        {cell_str, (if l>max_len, do: l, else: max_len)}
      end)  
    {List.to_tuple(column_str), width} 
    end
  end  
  
  def get_max_rows(columns_widths, rows_limit) do
    max_rows = Enum.reduce(columns_widths, 0, fn {column, _width}, max_rows ->
      if tuple_size(column)>max_rows, do: tuple_size(column), else: max_rows
    end)
    case max_rows > rows_limit do
      true -> {rows_limit, true}
      false -> {max_rows, false}
    end
  end
  
end  
