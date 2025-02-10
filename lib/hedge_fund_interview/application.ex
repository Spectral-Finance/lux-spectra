defmodule HedgeFundInterview.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HedgeFundInterviewWeb.Telemetry,
      HedgeFundInterview.Repo,
      {DNSCluster, query: Application.get_env(:hedge_fund_interview, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HedgeFundInterview.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HedgeFundInterview.Finch},
      # Start a worker by calling: HedgeFundInterview.Worker.start_link(arg)
      # {HedgeFundInterview.Worker, arg},
      # Start to serve requests, typically the last entry
      HedgeFundInterviewWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HedgeFundInterview.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HedgeFundInterviewWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
