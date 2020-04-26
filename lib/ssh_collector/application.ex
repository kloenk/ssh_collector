defmodule SSHCollector.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, args) do

    {config, _args} = parse_args(args)

    children = [
      {Plug.Cowboy, scheme: :http, plug: SSHCollector.Router, options: [port: config[:port]]},
      {SSHCollector.Config.Store, []}
      # Starts a worker by calling: SshCollector.Worker.start_link(arg)
      # {SshCollector.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SSHCollector.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp parse_args args do
    arg = OptionParser.parse!(args, switches: [port: :integer])
    arg
  end
end
