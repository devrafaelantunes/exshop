defmodule ExShop.Repo do
  use Ecto.Repo,
    otp_app: :ex_shop,
    adapter: Ecto.Adapters.Postgres
end
