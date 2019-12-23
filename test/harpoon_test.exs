defmodule HarpoonTest do
  use ExUnit.Case
  doctest Harpoon

  test "greets the world" do
    assert Harpoon.hello() == :world
  end
end
