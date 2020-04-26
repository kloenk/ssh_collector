defmodule SSHCollector.Collector.Scraper do
  alias SSHCollector.Collector.{Meminfo}

  def scrape(host, user, port, password) do
    {:ok, conn} = SSHEx.connect(ip: host, port: port, user: to_char_list(user), password: to_char_list(password))

    meminfo = Meminfo.get_meminfo(conn)


    meminfo
  end



end
