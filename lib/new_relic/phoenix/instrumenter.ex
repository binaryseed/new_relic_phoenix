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
    [
      default_name: NewRelic.Transaction.Plug.default_name(conn),
      status: status
    ]
    |> NewRelic.add_attributes()

    NewRelic.Phoenix.Transaction.Plug.before_send(conn)
    NewRelic.Transaction.Reporter.fail(error)
  end
end
