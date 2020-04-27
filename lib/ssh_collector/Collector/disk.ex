defmodule SSHCollector.Collector.Disk do
  @command_blocks "df -a --total"
  @command_inodes "df -ai --total"

  def get_disk conn do
    blocks = get_blocks conn
    inodes = get_inodes conn

    %{
      blocks: blocks,
      inodes: inodes,
    }
  end

  defp get_blocks conn do
    [_header | data_rows ] = SSHEx.cmd!(conn, @command_blocks, [])
    |> String.split("\n")

    data_rows
    |> parse_data_rows
  end

  defp get_inodes conn do
    [_header | data_rows ] = SSHEx.cmd!(conn, @command_inodes, [])
    |> String.split("\n")

    data_rows
    |> parse_data_rows()
  end

  defp parse_data_rows rows do
    rows
    |> Stream.map(fn(row) ->
      String.trim(row) |> String.split(" ", trim: true)
    end)
    |> Stream.filter(&not_empty?(&1))
    |> Stream.map(&parse_data_collumns(&1))
    |> Enum.into(%{})
  end

  defp parse_data_collumns(row) do
    case row do
      ["total", _total, used, available, _use_percentage, _mount_point] -> {:total, {used, available}}
      [type, _total, used, available, _use_percentage, mount_point] -> {mount_point, {used, available, type}}
    end
  end

  defp not_empty?(row) do
    case row do
      [] -> false
      _ -> true
    end
  end
end
