defmodule NewRelic.Phoenix.Instrumenter do
  def phoenix_error_render(
        :start,
        _compile,
        %{
          conn: conn,
          status: status,
          kind: kind,
          reason: reason,
          stacktrace: stack
        }
      ) do
    {conn, status, %{kind: kind, reason: reason, stack: stack}}
  end

  def phoenix_error_render(:stop, _time_diff, {conn, status, error}) do
    NewRelic.add_attributes(status: status)
    NewRelic.Phoenix.Transaction.Plug.before_send(conn)
    if status >= 500 do
      NewRelic.Transaction.Reporter.fail(error)
    end
  end
end
