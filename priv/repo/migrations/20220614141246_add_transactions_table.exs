defmodule ExShop.Repo.Migrations.AddTransactionsTable do
  use Ecto.Migration

  def change do
    create table("transactions") do
      add :transaction_id, :serial, primary_key: true

      add :type, :string
      add :date, :string
      add :value, :float # Should be decimal
      add :cpf, :string
      add :card, :string
      add :time, :string
      add :shop_owner, :string
      add :shop_name, :string

      timestamps()
    end

    create unique_index(:transactions, [:transaction_id])
  end
end
