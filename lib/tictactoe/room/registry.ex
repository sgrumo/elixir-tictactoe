defmodule Tictactoe.Room.Registry do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def register_room(name) do
    GenServer.call(__MODULE__, {:register_room, name})
  end

  def list_rooms() do
    GenServer.call(__MODULE__, {:list_rooms})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register_room, name}, _, state) do
    room_name = String.to_atom(name)
    {:ok, _pid} = GenServer.start_link(Tictactoe.Room, %{}, name: room_name)
    state = Map.put(state, name, room_name)
    {:reply, name, state}
  end

  @impl GenServer
  def handle_call({:list_rooms}, _, state) do
    res = Enum.map(state, fn {key, value} -> {key, value} end)
    {:reply, res, state}
  end

  @impl GenServer
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in #{__MODULE__}: #{inspect(msg)}")
    {:noreply, state}
  end
end
