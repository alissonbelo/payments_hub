defmodule PaymentsHubWeb.Router do
  use PaymentsHubWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PaymentsHubWeb do
    pipe_through :api

    get "/health", HealthController, :show
  end
end
