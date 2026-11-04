defmodule PaymentsHubWeb.HealthControllerTest do
  use PaymentsHubWeb.ConnCase, async: true

  test "GET /api/health retorna status ok", %{conn: conn} do
    conn = get(conn, ~p"/api/health")
    assert json_response(conn, 200) == %{"status" => "ok"}
  end
end
