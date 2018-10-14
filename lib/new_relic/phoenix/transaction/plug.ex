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
    set_transaction_name(conn)
    conn
  end

  def add_phoenix_attributes(%{
        private: %{phoenix_controller: controller, phoenix_action: action} = private
      }) do
    [
      phoenix_controller: inspect(controller),
      phoenix_action: action,
      phoenix_endpoint: inspect(private[:phoenix_endpoint]),
      phoenix_router: inspect(private[:phoenix_router]),
      phoenix_format: private[:phoenix_format],
      phoenix_template: private[:phoenix_template],
      phoenix_view: inspect(private[:phoenix_view])
    ]
    |> NewRelic.add_attributes()
  end

  def add_phoenix_attributes(_), do: :ignore

  def set_transaction_name(%{private: %{phoenix_controller: controller, phoenix_action: action}}) do
    NewRelic.add_attributes(framework_name: "/Phoenix/#{inspect(controller)}/#{action}")
  end

  def set_transaction_name(%{private: %{phoenix_endpoint: endpoint}} = conn) do
    NewRelic.add_attributes(framework_name: "/Phoenix/#{inspect(endpoint)}#{conn.request_path}")
  end

  def set_transaction_name(_), do: :ignore
end
