defmodule NewRelicPhoenixTest do
  use ExUnit.Case

  alias NewRelic.Harvest.Collector

  # Wire up and instrument our Endpoint
  defmodule TestEndpoint do
    use Phoenix.Endpoint, otp_app: :new_relic_phoenix
    use NewRelic.Phoenix.Transaction

    plug(:hello_world)

    defp hello_world(conn, _) do
      Plug.Conn.send_resp(conn, 200, "Hello, World")
    end
  end

  # Start up our HTTP Server
  @port 8882
  setup_all do
    Application.put_env(:new_relic_phoenix, TestEndpoint,
      http: [port: @port],
      server: true,
      instrumenters: [NewRelic.Phoenix.Instrumenter]
    )

    start_supervised(TestEndpoint)
    :ok
  end

  test "Report expected events!" do
    restart_harvest_cycle(Collector.TransactionEvent.HarvestCycle)

    %{body: body} = HTTPoison.get!("http://localhost:#{@port}/path")

    assert body == "Hello, World"

    [[_, tx_event]] = gather_harvest(Collector.TransactionEvent.Harvester)

    assert tx_event[:status] == 200
    assert tx_event[:path] == "/path"
  end

  defp restart_harvest_cycle(harvest_cycle) do
    GenServer.call(harvest_cycle, :restart)
  end

  defp gather_harvest(harvester) do
    Process.sleep(300)
    harvester.gather_harvest
  end
end
