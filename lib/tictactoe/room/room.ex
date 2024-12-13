defmodule Tictactoe.Room do
  use GenServer

  defstruct board: nil, players: nil, current_turn: nil, game_status: :waiting

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def make_move({position, schema} = _move) do
    GenServer.call(__MODULE__, {:make_move, {position, schema}})
  end

  def add_player(player_name) do
    GenServer.call(__MODULE__, {:add_player, player_name})
  end

  def list_players() do
    GenServer.call(__MODULE__, {:list_players})
  end

  def get_board() do
    GenServer.call(__MODULE__, {:get_board})
  end

  @impl GenServer
  def init(_) do
    state = %__MODULE__{
      board: init_board(),
      players: []
    }

    {:ok, state}
  end

  defp init_board do
    List.duplicate("", 9)
  end

  @impl GenServer
  def handle_call({:list_players}, _, %{players: players} = state) do
    {:reply, players, state}
  end

  @impl GenServer
  def handle_call({:add_player, player_name}, _, %{players: players} = state) do
    if length(players) == 2 do
      {:reply, "SIAMO PIENI FIGLIO DI PUTTANA", state}
    else
      {:reply, "Added #{player_name}", %{state | players: [player_name | players]}}
    end
  end

  @impl GenServer
  def handle_call(
        {:make_move, %{position: position, schema: schema}},
        _,
        %{board: board} = state
      ) do
    board = List.insert_at(board, position, schema)
    {:reply, "Ok", %{state | board: board}}
  end

  @impl GenServer
  def handle_call(
        {:get_board},
        _,
        %{board: board} = state
      ) do
    {:reply, board, state}
  end

  @impl GenServer
  def handle_info(msg, state) do
    require Logger
    Logger.debug("Unexpected message in #{__MODULE__}: #{inspect(msg)}")
    {:noreply, state}
  end
end
