defmodule Tictactoe.SocketRouter do
  require Logger
  @behaviour :cowboy_websocket

  def init(req, _opts) do
    IO.puts("Init Socket router")

    {
      :cowboy_websocket,
      req,
      %{},
      %{idle_timeout: 60_000, max_frame_size: 1_000_000}
    }
  end

  def websocket_init(state \\ %{}) do
    {:ok, state}
  end

  def websocket_handle({:text, "ping"}, state) do
    {:reply, {:text, "pong"}, state}
  end

  def websocket_handle({:text, msg}, state) do
    {:reply, {:text, msg}, state}
  end

  def terminate(_reason, _req, _state) do
    :ok
  end

  def websocket_info(_any, state) do
    state
  end
end
