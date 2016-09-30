defmodule TinyFair.Repo.Migrations.AddUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles) do
      add :rolename, :string, null: false
    end

    create unique_index(:user_roles, [:rolename])
  end
end
