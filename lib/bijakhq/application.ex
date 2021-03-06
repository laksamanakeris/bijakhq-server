defmodule Bijakhq.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Bijakhq.Repo, []),
      # Start the endpoint when the application starts
      supervisor(BijakhqWeb.Endpoint, []),
      # Start your own worker by calling: Bijakhq.Worker.start_link(arg1, arg2, arg3)
      # worker(Bijakhq.Worker, [arg1, arg2, arg3]),
      supervisor(BijakhqWeb.Presence, []),
      
      supervisor(Bijakhq.Game.Server, []),
      supervisor(Bijakhq.Game.Players, []),
      supervisor(Bijakhq.Game.GameManager, []),
      supervisor(Bijakhq.Game.Chat, []),
      supervisor(Bijakhq.Game.UserCounter, []),

      # worker(Immortal.ETSTableManager, [Bijakhq.Game.Server, [:public]])
      # worker(Immortal.ETSTableManager, [Bijakhq.Game.Chat, [:public]])
      # worker(Immortal.ETSTableManager, [Bijakhq.Game.Players, [:public]])
      
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bijakhq.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    BijakhqWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
