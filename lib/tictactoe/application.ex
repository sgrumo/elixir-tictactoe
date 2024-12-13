defmodule Tictactoe.Application do
  use Application

  defp dispatch do
    [
      {:_,
       [
         {"/ws", Tictactoe.SocketRouter, []},
         {:_, Plug.Cowboy.Handler, {Tictactoe.Router, []}}
       ]}
    ]
  end

  @impl true
  def start(_type, _args) do
    children = [
      {
        Plug.Cowboy,
        scheme: :http, plug: Tictactoe.Router, options: [dispatch: dispatch(), port: 3000]
      }
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]

    Supervisor.start_link(children, opts)
  end
end
