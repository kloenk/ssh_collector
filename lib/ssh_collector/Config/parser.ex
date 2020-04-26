defmodule SSHCollector.Config.Parser do

  @default_config "./config.json"

  def parse_config do
    read_file()
  end

  def parse_config(file) do
    read_file(file)
  end

  def read_file do
    read_file(@default_config)
  end

  def read_file(file) do
    File.read!(file)
    |> Jason.decode!()
  end
end
