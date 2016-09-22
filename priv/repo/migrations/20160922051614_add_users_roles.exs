defmodule TinyFair.Repo.Migrations.AddUsersRoles do
  use Ecto.Migration

  def change do
    create table(:users_roles, primary_key: false) do
      add :user_id, references(:users)
      add :user_role_id, references(:user_roles)
    end

    create index(:users_roles, [:user_id, :user_role_id], unique: true)
  end
end
