defmodule NewRelic.Phoenix.Transaction do
  defmacro __using__(_) do
    quote do
      plug(NewRelic.Transaction.Plug)
      plug(NewRelic.Phoenix.Transaction.Plug)
      plug(NewRelic.DistributedTrace.Plug)
    end
  end
end
