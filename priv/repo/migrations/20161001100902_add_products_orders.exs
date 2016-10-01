defmodule TinyFair.Repo.Migrations.AddProductsOrders do
  use Ecto.Migration

  def change do
    create table(:products_orders, primary_key: false) do
      add :product_id, references(:products)
      add :order_id, references(:orders)
    end
  end
end
