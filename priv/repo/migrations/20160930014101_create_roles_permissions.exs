defmodule TinyFair.Repo.Migrations.CreateRolesPermissions do
  use Ecto.Migration

  def change do
    create table(:user_roles_user_permissions, primary_key: false) do
      add :user_role_id, references(:user_roles)
      add :user_permission_id, references(:user_permissions)
    end
    create index(:user_roles_user_permissions,
      [:user_role_id, :user_permission_id], unique: true)
  end
end
