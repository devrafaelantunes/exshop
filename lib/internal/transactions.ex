defmodule ExShop.Internal.Transactions do
  @moduledoc """
    Camada interna das Transações.
  """

  @type changeset() :: map()
  @type transaction() :: map()

  alias ExShop.Repo
  alias ExShop.Model.Transactions, as: TransactionsModel

  @doc """
    Insere a transação no banco de dados e depois a retorna.
  """
  @spec insert_transaction(changeset()) :: transaction()
  def insert_transaction(transaction) do
    transaction
    |> TransactionsModel.create_changeset()
    |> Repo.insert()

    transaction
  end
end
