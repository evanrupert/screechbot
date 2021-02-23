defmodule ScreechbotTest do
  use ExUnit.Case
  doctest Screechbot

  test "greets the world" do
    assert Screechbot.hello() == :world
  end
end
