defmodule Bijakhq.Mixfile do
  use Mix.Project

  def project do
    [
      app: :bijakhq,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Bijakhq.Application, []},
      extra_applications: [:logger, :runtime_tools, :httpoison, :timex, :faker, :arc_ecto, :pay_pal, :singleton]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.0"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:phauxth, "~> 1.2"},
      {:bcrypt_elixir, "~> 1.1"},
      {:bamboo, "~> 0.8"},
      {:plug_cowboy, "~> 1.0"},
      {:httpoison, "~> 1.1.1", override: true},
      {:timex, "~> 3.1"},
      {:faker, "~> 0.10"},
      {:arc, "~> 0.10.0"},
      {:arc_ecto, "~> 0.10.0"},
      {:arc_gcs, "~> 0.0.8"},
      {:cors_plug, "~> 1.5"},
      {:pay_pal, github: "laksamanakeris/PayPal"},
      {:immortal, "~> 0.2.2"},
      {:libcluster, "~> 3.0", only: [:dev, :prod]},
      {:singleton, "~> 1.0.0"},
      {:distillery, "~> 2.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.drop", "ecto.create", "ecto.migrate", "test"]
    ]
  end
end
