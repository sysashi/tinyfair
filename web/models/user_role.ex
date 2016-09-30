defmodule TinyFair.UserRole do
  use TinyFair.Web, :model

  schema "user_roles" do
    field :rolename, :string

    many_to_many :users, User, join_through: "users_roles"
    many_to_many :permissions, UserPermission,
      join_through: "user_roles_user_permissions", on_replace: :delete
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rolename])
    |> validate_required([:rolename])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> cast_assoc(:permissions, required: true)
  end

  def set_permissions(struct, permissions) do
    struct
    |> changeset
    |> put_assoc(:permissions, permissions)
  end

  def with_permissions(query) do
    preload(query, :permissions)
  end
end
