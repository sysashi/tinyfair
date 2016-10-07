defmodule TinyFair.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :price, :integer, null: false, default: 0
      add :currency, :string, null: false
      add :unit, :string, null: false
      add :payable_services, {:array, :map}, default: []

      timestamps()
    end

    create constraint(:prices, :non_zero_price,
      check: "price > 0")

    create table(:products_prices, primary_key: false) do
      add :product_id, references(:products), null: false
      add :price_id, references(:prices), null: false
    end

    create unique_index(:products_prices, [:product_id, :price_id])

    create table(:orders) do
      add :amount, :integer, null: false, default: 1
      add :status, :string, null: false, default: "new"
      add :expiry, :utc_datetime
      add :chosen_services, {:array, :map}, default: []
      add :user_id, references(:users), null: false
      add :price_id, references(:prices), null: false

      timestamps()
    end

    create constraint(:orders, :non_zero_amount,
      check: "amount > 0")
    create constraint(:orders, :only_allowed_status,
      check: "status in ('new', 'accepted', 'declined', 'fulfilled')")
  end
end
