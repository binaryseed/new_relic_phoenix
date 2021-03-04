defmodule NewRelic.Phoenix.Transaction.Plug do
  @deprecated "Phoenix is now auto-instrumented via `telemetry`, please remove manual instrumentation."
  def init(opts), do: opts

  @deprecated "Phoenix is now auto-instrumented via `telemetry`, please remove manual instrumentation."
  def call(conn, _opts) do
    conn
  end
end
