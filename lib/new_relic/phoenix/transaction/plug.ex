defmodule NewRelic.Phoenix.Transaction.Plug do
  @behaviour Plug
  import Plug.Conn

  @impl Plug
  def init(opts), do: opts

  @impl Plug
  def call(conn, _opts) do
    conn
    |> register_before_send(&before_send/1)
  end

  def before_send(conn) do
    add_phoenix_attributes(conn)
    set_framework_name(conn)
    conn
  end

  def add_phoenix_attributes(%{
        private: %{phoenix_controller: controller, phoenix_action: action} = private
      }) do
    [
      "phoenix.controller": inspect(controller),
      "phoenix.action": action,
      "phoenix.endpoint": inspect(private[:phoenix_endpoint]),
      "phoenix.router": inspect(private[:phoenix_router]),
      "phoenix.format": private[:phoenix_format],
      "phoenix.template": private[:phoenix_template],
      "phoenix.view": inspect(private[:phoenix_view])
    ]
    |> NewRelic.add_attributes()
  end

  def add_phoenix_attributes(_), do: :ignore

  def set_framework_name(%{private: %{phoenix_controller: controller, phoenix_action: action}}) do
    NewRelic.add_attributes(framework_name: "/Phoenix/#{inspect(controller)}/#{action}")
  end

  def set_framework_name(%{private: %{phoenix_endpoint: endpoint}} = conn) do
    NewRelic.add_attributes(framework_name: "/Phoenix/#{inspect(endpoint)}#{conn.request_path}")
  end

  def set_framework_name(_), do: :ignore
end
