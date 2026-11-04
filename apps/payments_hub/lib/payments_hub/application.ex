defmodule PaymentsHub.Application do
  # See https://elixir.hexdocs.pm/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PaymentsHub.Repo,
      {DNSCluster, query: Application.get_env(:payments_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PaymentsHub.PubSub}
      # Start a worker by calling: PaymentsHub.Worker.start_link(arg)
      # {PaymentsHub.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PaymentsHub.Supervisor)
  end
end
