defmodule CalculatorServer do
  @moduledoc """
  Documentation for `CalculatorServer`.
  """
  @doc """
  Starts the calculator server by spawning the server function with an initial state
  Returns the process identifier (pid) of the spawned process function
  initial can only be an integer
  """
  @spec start(initial :: integer()) :: pid
  def start(initial \\ 0) when is_integer(initial) do
    spawn(fn -> calculator_server(initial) end)
  end

  @doc """
  Returns the value from the current state of the calculator server

  server_pid can only be of pid() of a process that is alive
  """
  @spec value(server_pid :: pid()) :: integer()
  def value(server_pid) do
    send(server_pid, {:report_state, self()})

    receive do
      {:ok, state} ->
        state
    end
  end

  @doc """
  Adds value to the current state of the calculator server
  """
  @spec add(pid(), integer()) :: {atom(), {pid(), integer()}}
  def add(server_pid, value), do: send(server_pid, {:add, {self(), value}})

  @doc """
  Subtract value from the current state of the calculator server
  """
  @spec sub(pid(), integer()) :: {atom(), {pid(), integer()}}
  def sub(server_pid, value), do: send(server_pid, {:sub, {self(), value}})

  @doc """
  Multiplies value and the current state of the calculator server
  """
  @spec mul(pid(), integer()) :: {atom(), {pid(), integer()}}
  def mul(server_pid, value), do: send(server_pid, {:mul, {self(), value}})

  @doc """
  Divides current state of the calculator server by value
  """
  @spec div(pid(), integer()) :: {atom(), {pid(), integer()}}
  def div(server_pid, value), do: send(server_pid, {:div, {self(), value}})

  @doc """
  Stops calculator server from running
  """
  @spec stop(pid()) :: {atom(), {pid(), integer()}}
  def stop(server_pid), do: send(server_pid, :stop)

  @spec calculator_server(integer()) :: any()
  defp calculator_server(state) do
    state =
      receive do
        {:report_state, server_pid} ->
          send(server_pid, {:ok, state})
          state

        {:add, {server_pid, value}} ->
          new_state = state + value
          send(server_pid, {:ok, new_state})
          new_state

        {:sub, {server_pid, value}} ->
          new_state = state - value
          send(server_pid, {:ok, new_state})
          new_state

        {:mul, {server_pid, value}} ->
          new_state = state * value
          send(server_pid, {:ok, new_state})
          new_state

        {:div, {server_pid, value}} ->
          new_state = state / value
          send(server_pid, {:ok, new_state})
          new_state

        :stop ->
          exit(:end)

        _ ->
          state
      end

    calculator_server(state)
  end
end
