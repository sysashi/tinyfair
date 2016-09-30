# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TinyFair.Repo.insert!(%TinyFair.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule Defaults do
  require TinyFair.Web
  TinyFair.Web.common_aliases

  def populate do
    default_permissions
    default_user_roles
  end

  defp default_permissions do
    User.Permissions.all
    |> Enum.map(& %UserPermission{permission: &1 |> Atom.to_string})
    |> Enum.map(& Repo.insert!(&1))
  end

  defp default_user_roles do
    roles =
      [%{rolename: "admin"},
       %{rolename: "user"},
       %{rolename: "seller"}]
      |> Enum.map(&default_permissions/1)
      |> Enum.map(&Repo.insert!/1)

  end
  defp map_permissions(role, permissions) do
    permissions = permissions
    |> Enum.map(& %{permission: &1 |> Atom.to_string})
    |> maybe_map_permissions_to_db

    UserRole.create_changeset(%UserRole{permissions: permissions}, role)
  end

  defp default_permissions(%{rolename: "admin"} = role) do
    map_permissions(role, User.Permissions.all)
  end

  defp default_permissions(%{rolename: "user"} = role) do
    map_permissions(role, User.Permissions.regular_user)
  end

  defp default_permissions(%{rolename: "seller"} = role) do
    map_permissions(role, User.Permissions.seller)
  end

  # FIXME
  defp maybe_map_permissions_to_db(permissions) do
    Enum.map(permissions, fn p ->
      if existing_perm = Repo.get_by(UserPermission, permission: p.permission) do
        existing_perm
      else
        p
      end
    end)
  end
end

Defaults.populate
