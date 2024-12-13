defmodule Tictactoe.Room.Supervisor do
  use Supervisor

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  @impl Supervisor
  def init(:ok) do
    children = [{Tictactoe.Room.Registry, name: Room.Registry}]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
