defmodule Screechbot do
  use Application

  def start(_type, _args) do
    children = [
      {Screechbot.State, nil},
      Screechbot.Listener
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Screechbot.Supervisor)
  end
end
