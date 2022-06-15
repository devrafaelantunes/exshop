defmodule ExShop.ProcessorTest do
  use ExUnit.Case, async: true

  alias ExShop.{Repo, Processor}

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  describe "start/1" do
    test "function returns and stores a transaction when a valid cnab file is passed" do
      sample_transaction = %{
        card: "4753****3153",
        cpf: "09620676017",
        date: "20190301",
        shop_name: "BAR DO JOÃO",
        shop_owner: "JOÃO MACEDO",
        time: "153453",
        type: "financiamento",
        value: 142
      }

      {:ok, string} = File.read("test/fixtures/cnb_file_example.txt")

      assert Processor.start(string) == [sample_transaction]

      stored_transaction = ExShop.Repo.get(ExShop.Model.Transactions, 1)

      assert stored_transaction.card == sample_transaction.card
      assert stored_transaction.cpf == sample_transaction.cpf
      assert stored_transaction.date == sample_transaction.date
      assert stored_transaction.shop_name == sample_transaction.shop_name
      assert stored_transaction.shop_owner == sample_transaction.shop_owner
      assert stored_transaction.time == sample_transaction.time
      assert stored_transaction.type == sample_transaction.type
      assert stored_transaction.value == sample_transaction.value
    end

    test "function returns and stores a transaction when a valid cnab file is passed even with missing params" do
      sample_transaction = %{
        card: "4753****3153",
        cpf: "09620676017",
        date: "20190301",
        shop_name: "",
        shop_owner: "JOÃO MACEDO",
        time: "153453",
        type: "financiamento",
        value: 142
      }

      {:ok, string} = File.read("test/fixtures/missing_cnb_file_example.txt")

      assert Processor.start(string) == [sample_transaction]
    end

    test "invalid cnab file" do
      assert Processor.start(123) == {:error, :wrong_transactions_format}
    end
  end
end
