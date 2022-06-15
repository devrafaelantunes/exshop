defmodule ExShop.Model.TransactionsTest do
  use ExUnit.Case

  alias ExShop.Model.Transactions

  @sample_transaction %{
    card: "4753****3153",
    cpf: "09620676017",
    date: "20190301",
    shop_name: "BAR DO JOÃO",
    shop_owner: "JOÃO MACEDO",
    time: "153453",
    type: "financiamento",
    value: 142
  }

  describe "create_changeset/1" do
    test "returns changeset when valid parameters are passed" do
      changeset = Transactions.create_changeset(@sample_transaction)

      assert changeset.valid? == true
    end

    test "returns invalid changeset when parameters are missing" do
      changeset =
        @sample_transaction
        |> Map.drop([:cpf])
        |> Transactions.create_changeset()

      refute changeset.valid? == true
    end
  end
end
