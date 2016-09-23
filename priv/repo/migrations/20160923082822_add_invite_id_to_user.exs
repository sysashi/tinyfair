defmodule TinyFair.Repo.Migrations.AddInviteIdToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :invite_id, references(:invites)
    end
  end
end
