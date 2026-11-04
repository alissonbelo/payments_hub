defmodule PaymentsHubWeb.HealthController do
  use PaymentsHubWeb, :controller

  def show(conn, _params) do
    json(conn, %{status: "ok"})
  end
end
