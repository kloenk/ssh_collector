defmodule SSHCollector.Config.Store do
  use GenServer
  alias SSHCollector.Config.Parser

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :ssh_collector_config_store)
  end

  def start_link(arg) do
    start_link() # FIXME: parse config file to use
  end

  def init(_) do
    {:ok, Parser.parse_config}
  end

  def get_config do
    GenServer.call(:ssh_collector_config_store, {:get_config})
  end

  def get_config(region) do
    GenServer.call(:ssh_collector_config_store, {:get_config, region})
  end

  def get_config(region, server) do
    GenServer.call(:ssh_collector_config_store, {:get_config, region, server})
  end

  def reload do
    GenServer.cast(:ssh_collector_config_store, {:reload_config})
  end

  def reload(file) do
    GenServer.cast(:ssh_collector_config_store, {:reload_config, file})
  end

  # Callbacks
  def handle_call({:get_config}, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:get_config, region}, _from, state) do
    config = state["servers"][region]
    {:reply, config, state}
  end

  def handle_call({:get_config, region, server}, _from, state) do
    config = state["servers"][region][server]
    {:reply, config, state}
  end

  def handle_cast({:reload_config}, _state) do
    {:noreply, Parser.parse_config}
  end

  def handle_cast({:reload_config, file}, _state) do
    {:noreply, Parser.parse_config(file)}
  end

end
