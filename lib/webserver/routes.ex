defmodule ExShop.WebServer.Routes do
  @moduledoc """
    Expõe rotas HTTP utilizando o Cowboy
  """

  alias ExShop.WebServer.Handler

  @doc """
    Rotas disponíveis :
    GET localhost:3000/transactions - Recebe um CNAB File e retorna as transações
    processadas em formato de JSON.
  """
  @type routes ::
          [
            {String.t(), handler :: Module, args :: map}
          ]
  def routes() do
    [
      {"/transactions", Handler, %{endpoint: :process_transactions}}
    ]
  end

  @doc """
    Recompila as rotas em runtime
  """
  def recompile() do
    dispatch = :cowboy_router.compile([{:_, routes()}])
    :persistent_term.put(:exnews_dispatch, dispatch)
  end
end
