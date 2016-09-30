defmodule TinyFair.UserHelpers do
  import TinyFair.Utils
  import Ecto.Changeset, only: [put_assoc: 3]
  import Ecto.Query, only: [where: 2, where: 3]
  use TinyFair.Web, :aliases

  def new_user(registration_params, invite \\ nil) do
    user = if invite do
      Ecto.build_assoc(invite, :invitee)
    else
      %User{}
    end
    default_registration_role = [:user] |> map_atoms |> load_roles |> Repo.all
    User.registration_changeset(user, registration_params)
    |> User.set_roles(default_registration_role)
    |> Repo.insert
  end

  def load_roles(list) do
    where(UserRole, [r], r.rolename in ^list)
  end

  def load_permissions(list) do
    where(UserPermission, [p], p.permission in ^list)
  end

  defp map_atoms(list) do
    list = list |>
    Enum.map(fn
      p when is_atom(p) -> Atom.to_string(p)
      p when is_binary(p) -> p
    end)
  end

  defp many_by_ids(model, ids) when is_list(ids) do
    model |> where([m], m.id in ^ids)
  end
end
