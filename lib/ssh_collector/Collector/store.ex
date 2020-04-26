defmodule SSHCollector.Collector.Store do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :ssh_collector_collector_store)
  end

  def init(state) do
    :ssh.start()
    {:ok, state}
  end
end
