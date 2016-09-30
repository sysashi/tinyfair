defmodule TinyFair.User.Permissions.Helpers do
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      @before_compile unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :permissions, accumulate: true)
    end
  end

  defp create_permissions(permissions) do
    permissions
    |> Enum.filter(&(Atom.to_string(&1) |> String.starts_with?("can")))
    |> Enum.map(&{can_to(&1), &1})
    |> Enum.map(&create_permission(&1))
    |> Kernel.++([create_helpers])
  end

  defp create_permission(name, permission) do
    quote do
      def unquote(name)(user) do
        user_perms = unpack_permissions(user.roles)
        if unquote(permission) in user_perms do
          true
        else
          false
        end
      end
    end
  end

  defp create_permission({name, permission}) do
    create_permission(name, permission)
  end

  def unpack_permissions(roles) do
    roles
    |> Enum.flat_map(fn role ->
      role.permissions
      # TODO FIXME
      |> Enum.map(&(String.to_atom(&1.permission)))
    end)
  end

  defp create_helpers do
    quote do
      def all, do: @permissions |> List.flatten
    end
  end

  defp to_list(list_of_structs, perm_key \\ :permission) do
    list_of_structs
    |> Enum.map(&(&1[perm_key]))
  end

  defp can_to(permission) when is_atom(permission) do
    can_to(Atom.to_string(permission))
  end

  defp can_to(permission) when is_binary(permission) do
    permission
    |> String.replace_leading("can", "to")
    |> Kernel.<>("?")
    |> String.to_atom
  end

  defmacro __before_compile__(_env) do
    Module.get_attribute(__CALLER__.module, :permissions)
    |> List.flatten
    |> create_permissions
  end
end
