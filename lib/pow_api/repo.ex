defmodule PowApi.Repo do
  use Ecto.Repo,
    otp_app: :pow_api,
    adapter: Ecto.Adapters.Postgres
end
