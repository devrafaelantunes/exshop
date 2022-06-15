defmodule ExShop.Model.Transactions do
  @moduledoc """
    Camada criada para lidar com o Schema das transações
  """

  @type changeset() :: map()

  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:transaction_id, :id, autogenerate: true}
  schema "transactions" do
    field(:type, :string)
    field(:date, :string)
    field(:value, :float)
    field(:cpf, :string)
    field(:card, :string)
    field(:time, :string)
    field(:shop_owner, :string)
    field(:shop_name, :string)

    timestamps()
  end

  @doc """
    Cria um Changeset Struct com os parametros descritos na documentação.
  """
  @spec create_changeset(map()) :: changeset()
  def create_changeset(params) do
    list_of_params = [:type, :date, :value, :cpf, :card, :time, :shop_owner, :shop_name]

    %__MODULE__{}
    |> cast(params, list_of_params)
    |> validate_required(list_of_params)
  end
end
