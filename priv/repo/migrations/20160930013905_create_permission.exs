defmodule TinyFair.Repo.Migrations.CreatePermission do
  use Ecto.Migration

  def change do
    create table(:user_permissions) do
      add :permission, :string, null: false
    end

    create unique_index(:user_permissions, [:permission])
  end
end
