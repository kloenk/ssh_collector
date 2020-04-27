defmodule SSHCollector.Collector.Store do
  use GenServer
  alias SSHCollector.Config.Store
  alias SSHCollector.Collector.Scraper

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :ssh_collector_collector_store)
  end

  def start_link(_) do
    start_link()
  end

  def init(state) do
    :ssh.start()
    # FIXME: scrape all initialy
    {:ok, state}
  end

  def scrape() do
    GenServer.cast(:ssh_collector_collector_store, {:scrape})
  end

  def scrape(region) do
    GenServer.cast(:ssh_collector_collector_store, {:scrape, region})
  end

  def scrape(region, server) do
    GenServer.cast(:ssh_collector_collector_store, {:scrape, region, server})
  end

  def get() do
    GenServer.call(:ssh_collector_collector_store, {:get})
  end

  def get(region) do
    GenServer.call(:ssh_collector_collector_store, {:get, region})
  end

  def get(region, server) do
    GenServer.call(:ssh_collector_collector_store, {:get, region, server})
  end

  # Callbacks
  def handle_cast({:scrape, region, server}, state) do
    IO.puts("scrape server: #{region}/#{server}")
    {host, username, password, port} = Store.get_config(region, server)
    |> get_config

    {:ok, data} = Scraper.scrape(host, username, password, port)

    region_map = Map.put(get_region(region, state), server, data)
    state = Map.put(state, region, region_map)
    {:noreply, state}
  end

  def handle_cast({:scrape, region}, state) do
    IO.puts("scrape region #{region}")
    Store.get_config(region)
    |> Map.to_list
    |> scrape_region(region)

    {:noreply, state}
  end

  def handle_cast({:scrape}, state) do
    Store.get_config()["servers"]
    |> Map.to_list()
    |> scrape_all

    {:noreply, state}
  end

  def handle_call({:get}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get, region}, _from, state) do
    region = Map.get(state, region)
    {:reply, region, state}
  end

  def handle_call({:get, region, server}, _from, state) do
    region = Map.get(state, region)
    server = Map.get(region, server)
    {:reply, server, state}
  end


  # Helper functions
  defp get_config(config) do
    username = get_value(config, "username", "root")
    host = get_value(config, "ip")
    password = get_value(config, "password")
    port = get_value(config, "port", 22)

    {host, username, password, port}
  end

  defp get_value(config, name, default \\ nil) do
    case config[name] do
      nil -> default
      value -> value
    end
  end

  defp scrape_region([head | tail], region) do
    scrape_region(tail, region)
    server = get_name(head)
    GenServer.cast(:ssh_collector_collector_store, {:scrape, region, server})
  end

  defp scrape_region([], _region) do
    {:noreply}
  end

  defp scrape_all([head | tail]) do
    scrape_all(tail)
    region = get_name(head)
    GenServer.cast(:ssh_collector_collector_store, {:scrape, region})
  end

  defp scrape_all([]) do
    {:noreply}
  end

  defp get_name(config) do
    {name, _} = config
    name
  end

  defp get_region(region, state) do
    case state[region] do
      nil -> %{}
      v -> v
    end
  end
end



#def scrape() do
#  config_list = Map.to_list Store.get_config()["servers"]
#  case get_name config_list do
#    {name} -> scrape(name)
#    {name, config} -> scrape(name)
#  end
#end
#
#defp get_name(config_list) do
#  case config_list do
#    [name | config_list] -> {get_name_inner(name), config_list}
#    [name] -> {get_name_inner name}
#  end
#end
#
#defp get_name_inner(config) do
#  {name, _} = config
#  name
#end
