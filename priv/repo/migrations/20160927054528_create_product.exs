defmodule TinyFair.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string, null: false
      add :quantity, :integer, null: false, default: 0
      add :image_url, :string
      add :desc, :string
      add :status, :string, null: false, default: "stash"
      add :user_id, references(:users, on_delete: :nothing), null: false

      add :deleted_at, :utc_datetime
      timestamps()
    end
    create index(:products, [:user_id])
    create unique_index(:products, [:name])

    create constraint(:products, :non_negative_quantity,
      check: "quantity >= 0")
    create constraint(:products, :only_allowed_status,
      check: "status in ('instock', 'outstock', 'hidden', 'stash')")
  end
end
