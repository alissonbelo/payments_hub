defmodule PaymentsHub.Repo do
  use Ecto.Repo,
    otp_app: :payments_hub,
    adapter: Ecto.Adapters.Postgres
end
