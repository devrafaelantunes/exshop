defmodule ExShop.Processor do
  @moduledoc """
    Módulo responsável por processar, parsear e armazenar as informações provenientes de arquivos CNAB.
  """

  # Typespecs
  @type transactions() :: String.t()

  alias ExShop.Internal.Transactions, as: TransactionsInternal

  @doc """
    Processa o arquivo CNAB. Recebendo-o como primeiro argumento. O arquivo deve ser passado como uma
    string.

    Utiliza-se a biblioteca Flow para processar o arquivo, assim utilizando GenStage para realizar o 
    processamento em paralelo concorrentemente, aumentando a performance.

    A função também utiliza o módulo Task para parsear e formatar o conteúdo da transação.
    
    Após o processamento, a função chama o módulo `TransactionsInternal` para salvar as informações no
    banco de dados.

    IMPORTANTE: O arquivo CNAB deve estar formatado da forma em que foi descrito na descrição do desafio
  """
  @spec start(transactions) :: list(map())
  def start(transactions) when is_binary(transactions) do
    transactions
    |> String.codepoints()
    # Separa as transações
    |> Stream.chunk_every(80)
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn list ->
      Task.async(fn ->
        transaction_list = Enum.join(list)

        # Divide a transação para obter todas as informações necessárias
        {type, tns} = String.split_at(transaction_list, 1)
        {date, tns} = String.split_at(tns, 8)
        {value, tns} = String.split_at(tns, 10)
        {cpf, tns} = String.split_at(tns, 11)
        {card, tns} = String.split_at(tns, 12)
        {time, tns} = String.split_at(tns, 6)
        {shop_owner, tns} = String.split_at(tns, 14)
        {shop_name, _tns} = String.split_at(tns, 19)

        # Parsea e trata todas as informações, retornando um mapa contendo todas elas
        %{
          type: type |> define_transaction_type(),
          date: date,
          value: value |> String.to_integer() |> div(100),
          cpf: cpf,
          card: card,
          time: time,
          shop_owner: shop_owner |> String.trim(),
          shop_name: shop_name |> String.trim()
        }
        # Insere a transação no banco de dados
        |> TransactionsInternal.insert_transaction()
      end)
      |> Task.await()
    end)
    |> Enum.to_list()
  end

  # Simples error handling. A função só deve aceitar transações no formato binário
  @spec start(any()) :: {:error, :wrong_transactions_format}
  def start(_), do: {:error, :wrong_transactions_format}

  # Define o tipo de transação baseado na documentação provida pelo desafio
  defp define_transaction_type(type) do
    transactions_type = %{
      "1" => "debito",
      "2" => "boleto",
      "3" => "financiamento",
      "4" => "credito",
      "5" => "recebimento_emprestimo",
      "6" => "vendas",
      "7" => "recebimento_ted",
      "8" => "recebimento_doc",
      "9" => "aluguel"
    }

    # Busca o tipo de transação dentro do mapa. Se caso não encontrar, a transação
    # será definida como "desconhecida"
    Map.get(transactions_type, type, "unknown")
  end
end
