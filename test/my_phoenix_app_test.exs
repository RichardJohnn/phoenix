defmodule MyPhoenixAppTest do
  use ExUnit.Case
  doctest MyPhoenixApp

  test "greets the world" do
    assert MyPhoenixApp.hello() == :world
  end
end
