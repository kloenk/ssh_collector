defmodule SSHCollector.Collector.Scraper do
  alias SSHCollector.Collector.{Meminfo, Load, Disk, Uptime}

  def scrape(host, user, password, port \\ 22) do
     conn = SSHEx.connect(ip: host, port: port, user: to_char_list(user), password: to_char_list(password), negotiation_timeout: 100, timeout: 100)
     case conn do
       {:ok, conn} -> {:ok, do_scrape conn}
       {:error, _e} -> {:ok, false}
     end
  end

  defp do_scrape(conn) do
    meminfo = Meminfo.get_meminfo(conn)
    load = Load.get_load conn
    disk = Disk.get_disk conn
    uptime = Uptime.get_uptime conn

    %{
      meminfo: meminfo,
      load: load,
      disk: disk,
      uptime: uptime
    }
  end

end
