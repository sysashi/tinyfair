defmodule TinyFair.Repo.Migrations.AddUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :password_hash, :string, null: false

      add :email, :string
      add :phone, :string
      add :line_id, :string

      add :status, :string, null: false, default: "active"
      add :level, :float, null: false, default: 0.0

      timestamps()
    end
    create unique_index(:users, [:username])

    create constraint(:users, :only_allowed_status,
      check: "status in ('active', 'hidden', 'banned')")
  end
end
