defmodule TinyFair.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :amount, :integer, null: false, default: 1
      add :status, :string, null: false, default: "new"
      add :expiry, :utc_datetime
      add :extra_fees, :map
      add :metainfo, :map
      add :user_id, references(:users), null: false

      timestamps()
    end

    create constraint(:orders, :non_zero_amount,
      check: "amount > 0")
    create constraint(:orders, :only_allowed_status,
      check: "status in ('new', 'accepted', 'declined', 'fulfilled')")
  end
end
