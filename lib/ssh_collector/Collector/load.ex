defmodule SSHCollector.Collector.Load do
  @file_path "/proc/loadavg"

  def get_load(conn) do
    SSHEx.cmd!(conn, "cat #{@file_path};", [])
    |> String.split(" ")
    |> format
  end

  defp format(data) do
    [load1, load5, load15, tasks, _] = data
    [threads, threads_total] = parse_tasks tasks
    %{
      load1: load1,
      load5: load5,
      load15: load15,
      threads: threads,
      threads_total: threads_total
    }
  end

  defp parse_tasks tasks do
    tasks |> String.split("/")
  end

end
