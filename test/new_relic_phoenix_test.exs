defmodule NewRelicPhoenixTest do
  use ExUnit.Case

  defmodule TestEndpoint do
    use Phoenix.Endpoint, otp_app: :new_relic_phoenix

    plug(:hello_world)

    defp hello_world(conn, _) do
      Plug.Conn.send_resp(conn, 200, "Hello, World")
    end
  end

  @port 8882
  test "greets the world" do
    Application.put_env(:new_relic_phoenix, TestEndpoint, http: [port: @port], server: true)
    TestEndpoint.start_link()

    %{body: body} = HTTPoison.get!("http://localhost:#{@port}/")

    assert body == "Hello, World"
  end
end
