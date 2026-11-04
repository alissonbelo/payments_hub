defmodule PaymentsHubWeb.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PaymentsHubWeb.Telemetry,
      # Start a worker by calling: PaymentsHubWeb.Worker.start_link(arg)
      # {PaymentsHubWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      PaymentsHubWeb.Endpoint
    ]

    # See https://elixir.hexdocs.pm/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PaymentsHubWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PaymentsHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
