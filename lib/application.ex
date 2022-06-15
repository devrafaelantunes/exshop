defmodule ExShop.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ExShop.Repo,
      cowboy_child_spec()
    ]

    opts = [strategy: :one_for_one, name: ExShop.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Especificações do cowboy
  defp cowboy_child_spec() do
    dispatch = :cowboy_router.compile([{:_, ExShop.WebServer.Routes.routes()}])
    :persistent_term.put(:exshop_dispatch, dispatch)

    %{
      id: :server,
      start: {
        :cowboy,
        :start_clear,
        [
          :server,
          %{
            socket_opts: [port: 3000],
            max_connections: 16_384,
            num_acceptors: 8
          },
          %{env: %{dispatch: {:persistent_term, :exshop_dispatch}}}
        ]
      },
      restart: :permanent,
      shutdown: :infinity,
      type: :supervisor
    }
  end
end
