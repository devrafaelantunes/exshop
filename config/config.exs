use Mix.Config

config :ex_shop, :ecto_repos, [ExShop.Repo]

import_config "#{Mix.env()}.exs"
