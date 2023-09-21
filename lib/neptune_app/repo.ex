defmodule NeptuneApp.Repo do
  use Ecto.Repo,
    otp_app: :neptune_app,
    adapter: Ecto.Adapters.Postgres
end
