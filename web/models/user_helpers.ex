defmodule TinyFair.UserHelpers do
  import TinyFair.Utils
  import Ecto.Changeset, only: [put_assoc: 3]
  import Ecto.Query, only: [where: 3]
  use TinyFair.Web, :aliases

  # TODO: make it add or is this function really needed?
  def set_role(changeset, role_id) when is_integer(role_id) or is_binary(role_id) do
    if role = Repo.get(UserRole, role_id) do
      set_role(changeset, role)
    else
      {:error, "Non existing user role"}
    end
  end

  def set_role(changeset, %UserRole{} = role) do
    set_roles(changeset, [role])
  end

  # TODO: deal with list of ids
  # @spec put_roles(User.t, [UserRole.t]) :: Ecto.Changeset.t
  def set_roles(%User{} = user, roles), do: set_roles(Ecto.Changeset.change(user), roles)

  @spec set_roles(Ecto.Changeset.t, [UserRole.t]) :: Ecto.Changeset.t
  def set_roles(%Ecto.Changeset{data: data} = changeset, roles) when is_list(roles) do
    # FIXME
    if list_of_integers?(roles) and length(roles) > 0 do
      set_roles(changeset, many_by_ids(UserRole, roles) |> Repo.all)
    else
      # have to preload current user roles?
      data = data |> Repo.preload(:roles)
      %{changeset | data: data}
      |> put_assoc(:roles, roles)
    end
  end

  defp many_by_ids(model, ids) when is_list(ids) do
    model |> where([m], m.id in ^ids)
  end
end
