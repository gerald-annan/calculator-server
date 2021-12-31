defmodule CalculatorServerTest do
  use ExUnit.Case
  doctest CalculatorServer

  test "greets the world" do
    assert CalculatorServer.hello() == :world
  end
end
