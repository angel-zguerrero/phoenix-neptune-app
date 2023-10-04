defmodule NeptuneApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      NeptuneAppWeb.Telemetry,
      # Start the Ecto repository
      NeptuneApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: NeptuneApp.PubSub},
      # Start Finch
      {Finch, name: NeptuneApp.Finch},
      # Start the Endpoint (http/https)
      NeptuneAppWeb.Endpoint,
      # Start a worker by calling: NeptuneApp.Worker.start_link(arg)
      # {NeptuneApp.Worker, arg}
      NeptuneAppWeb.TyrantApi.TyrantApiIntegrationScheduler,
      {NeptuneAppWeb.TyrantApi.TyrantApiIntegration, [strategy: :one_for_one]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: NeptuneApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NeptuneAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
