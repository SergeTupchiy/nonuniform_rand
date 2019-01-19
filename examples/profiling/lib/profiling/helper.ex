defmodule Profiling.Helper do

  defmacro exec_with_time(exec_name, units \\ :milliseconds, do: exec_code) do
    quote do
      start_time = System.monotonic_time(unquote(units))
      result = unquote(exec_code)
      end_time = System.monotonic_time(unquote(units))
      IO.puts("Task #{inspect(unquote(exec_name))} executed in: #{end_time - start_time} #{unquote(units)}")
      result
    end
  end

  def get_relative_freqs(generated_values) do
    len = length(generated_values)
    Enum.group_by(generated_values, &(&1))
    |> Enum.map(fn({key, val}) -> {key, length(val) / len} end)
  end

  def get_lines_from_file(file_name) do
    get_str_from_file(file_name)
    |> String.split("\n")
  end

  def get_str_from_file(file_name) do
    file_path = Application.get_application(__MODULE__)
                |> Application.app_dir()
                |> Path.join("priv")
                |> Path.join("resources")
                |> Path.join(file_name)
    case :file.read_file(file_path) do
      {:ok, data} ->
        data
      {:error, reason} ->
        raise "Failed to read Countries config file, path: #{file_path}, reason: #{reason}"
    end
  end

  def parse_lines([], acc) do
    acc
  end

  def parse_lines([line|t], acc) when is_list(acc) do
    new_acc = [parse_line(line) | acc]
    parse_lines(t, new_acc)
  end

  def parse_lines([line|t], acc) when is_map(acc) do
    {key, value} = parse_line(line)
    new_acc = Map.put(acc, key, value)
    parse_lines(t, new_acc)
  end

  def parse_line(line) do
    [key|[value|[]]] = String.split(line, ",")
    {key, String.replace(value, ~r{\r|\s}, "") |> Float.parse() |> elem(0)}
  end

end
