defmodule TinyFair.UserPermission do
  use TinyFair.Web, :model

  schema "user_permissions" do
    field :permission

    many_to_many :user_roles, UserRole,
      join_through: "user_roles_user_permissions"
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:permission])
  end
end
