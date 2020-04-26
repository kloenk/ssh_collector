defmodule SSHCollector.Collector.Meminfo do
  @file "/proc/meminfo"

  def get_meminfo(conn) do
    SSHEx.cmd!(conn, "cat /proc/meminfo", [])
    |> String.split("\n")
    |> Stream.map(fn(row) ->
      String.trim(row)
      |> String.split()
    end)
    |> Stream.filter(&non_empty?(&1))
    |> Stream.map(&format_row(&1))
    |> Enum.into(%{})
  end

  defp format_row(row) do
    case row do
      [name, value] -> {String.trim(name, ":"), {value}}
      [name, value, size] -> {String.trim(name, ":"), {value, size}}
    end
  end

  defp non_empty?(row) do
    case row do
      [] -> false
      _ -> true
    end
  end
end
