defmodule SSHCollector.Router do
  use Plug.Router
  use Plug.Debugger
  require Logger

  plug(:match)

  plug(:dispatch)

  get "/" do
    send_resp(conn, 200, "/metrics")
  end


  # 404
  match _ do
    send_resp(conn, 404, "not found")
  end

end
