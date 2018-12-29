defmodule NewRelicPhoenixTest do
  use ExUnit.Case

  alias NewRelic.Harvest.Collector

  # Wire up and instrument our Phoenix App
  @port 8882
  Application.put_env(:new_relic_phoenix, __MODULE__.TestEndpoint,
    http: [port: @port],
    server: true,
    instrumenters: [NewRelic.Phoenix.Instrumenter]
  )

  defmodule TestController do
    use Phoenix.Controller
    def index(conn, _params), do: text(conn, "Hello, World")
    def error(_conn, _params), do: raise("BAD")
  end

  defmodule ErrorView do
    def render(_, _), do: "Error"
  end

  defmodule TestRouter do
    use Phoenix.Router
    get "/", TestController, :index
    get "/error", TestController, :error
  end

  defmodule TestEndpoint do
    use Phoenix.Endpoint, otp_app: :new_relic_phoenix
    use NewRelic.Phoenix.Transaction
    plug TestRouter
  end

  # Start up our HTTP Server
  setup_all do
    TestEndpoint.start_link()
    :ok
  end

  test "Report expected events!" do
    restart_harvest_cycle(Collector.TransactionEvent.HarvestCycle)

    %{body: body} = HTTPoison.get!("http://localhost:#{@port}/")

    assert body == "Hello, World"

    [[_, tx_event]] = gather_harvest(Collector.TransactionEvent.Harvester)

    assert tx_event[:status] == 200
    assert tx_event[:path] == "/"
    refute tx_event[:error]
    assert tx_event[:framework_name] == "/Phoenix/NewRelicPhoenixTest.TestController/index"
    assert tx_event[:"phoenix.controller"] == "NewRelicPhoenixTest.TestController"
  end

  @tag :capture_log
  test "Report expected events when there is an error" do
    restart_harvest_cycle(Collector.TransactionEvent.HarvestCycle)

    %{body: body} = HTTPoison.get!("http://localhost:#{@port}/error")

    assert body == "Error"

    [[_, tx_event]] = gather_harvest(Collector.TransactionEvent.Harvester)

    assert tx_event[:status] == 500
    assert tx_event[:path] == "/error"
    assert tx_event[:error] == true
    assert tx_event[:framework_name] == "/Phoenix/NewRelicPhoenixTest.TestController/error"
    assert tx_event[:"phoenix.controller"] == "NewRelicPhoenixTest.TestController"
  end

  defp restart_harvest_cycle(harvest_cycle) do
    GenServer.call(harvest_cycle, :restart)
  end

  defp gather_harvest(harvester) do
    Process.sleep(300)
    harvester.gather_harvest
  end
end
