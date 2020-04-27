defmodule SSHCollector.Collector.Uptime do
  @file_path "/proc/uptime"

  def get_uptime conn do
    uptime = SSHEx.cmd!(conn, "cat #{@file_path}", [])
    |> String.split(" ")
    |> Stream.map(&String.trim(&1))
    |> Stream.map(&String.to_float(&1))
    |> Enum.into([])

    [uptime, core_idle] = uptime
    {uptime, core_idle}
  end

end
