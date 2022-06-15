defmodule ExShop.WebServer.Handler do
  @moduledoc """
    Utiliza a biblioteca Cowboy para lidar com requisições HTTP
  """

  alias ExShop.Processor

  @type request :: map

  @doc """
    ENDPOINT: localhost:3000/transactions

    Recebe um CNAB File em forma de string através da Query String, e retorna
    todas as transações processadas, armazenadas e parseadas.
  """
  def init(request, %{endpoint: :process_transactions}) do
    # Conteúdo JSON
    request = set_content_type(request)

    # Parseia a CNAB File presente nos parametros da query
    cnab_file =
      request
      |> :cowboy_req.parse_qs()
      |> Map.new()
      |> Map.get("cnab_file")

    # Processa e encoda as transações
    transactions =
      Processor.start(cnab_file)
      |> Jason.encode!()

    # Retorna as transações
    {:ok, set_reply(request, transactions, 201), transactions}
  end

  @spec set_content_type(request) ::
          request
  defp set_content_type(request) do
    :cowboy_req.set_resp_header("content-type", "application/json; charset=utf-8", request)
  end

  @spec set_reply(request, body :: String.t(), status_code :: pos_integer) ::
          request
  defp set_reply(request, body, status_code) do
    :cowboy_req.reply(status_code, %{}, body, request)
  end
end
