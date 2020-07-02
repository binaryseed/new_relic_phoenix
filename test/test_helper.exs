{:ok, _} = NewRelic.EnabledSupervisor.start_link(:ok)

ExUnit.start()
