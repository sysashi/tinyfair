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
    default_user_roles
  end

  defp default_user_roles do
    roles =
      [%{rolename: "admin"},
       %{rolename: "user"},
       %{rolename: "seller"}]
    Repo.insert_all(UserRole, roles)
  end
end

Defaults.populate
