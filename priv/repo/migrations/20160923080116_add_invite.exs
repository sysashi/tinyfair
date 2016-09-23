defmodule TinyFair.Repo.Migrations.AddInvite do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :user_id, references(:users)
      add :user_role_id, references(:user_roles)
      add :token, :string
      add :expiry, :datetime
      add :activated_at, :datetime

      timestamps()
    end
  end
end
