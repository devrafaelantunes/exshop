use Mix.Config

config :ex_shop, ExShop.Repo,
  username: "postgres",
  password: "postgres",
  database: "exshop_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
