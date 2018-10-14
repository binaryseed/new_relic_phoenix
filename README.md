# New Relic Phoenix

This package adds Phoenix specific instrumentation on top of the `new_relic_agent` package. You may use all the built-in capabilities of the New Relic Agent!

Check out the agent for more:
* https://github.com/newrelic/elixir_agent
* https://hexdocs.pm/new_relic_agent

## Installation

* Install the [Hex package](https://hex.pm/packages/new_relic_phoenix)

* Cowboy 2 is required. Phoenix support was introduced in `1.4`

```elixir
defp deps do
  [
    {:new_relic_phoenix, "~> 1.0"},
    {:phoenix, "~> 1.4.0-rc"},
    {:cowboy, "~> 2.5"}
  ]
end
```

## Configuration

* You must configure `new_relic_agent` to authenticate to New Relic. Please see: https://github.com/newrelic/elixir_agent/#configuration

## Instrumentation

* Inside your Phoenix Endpoint module, `use` the `NewRelic.Phoenix.Transaction` module:

```elixir
defmodule MyApp.Endpoint do
  use Phoenix.Endpoint, otp_app: :my_app
  use NewRelic.Phoenix.Transaction
  # ...
end
```

* In your Phoenix Endpoint configuration, add the instrumenter:

```elixir
config :my_app, MyApp.Endpoint,
  instrumenters: [NewRelic.Phoenix.Instrumenter]
```


