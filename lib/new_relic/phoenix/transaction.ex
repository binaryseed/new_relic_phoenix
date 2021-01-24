defmodule NewRelic.Phoenix.Transaction do
  @deprecated "Phoenix is now auto-instrumented via `telemetry`, please remove manual instrumentation."
  defmacro __using__(_) do
    :not_needed!
  end
end
