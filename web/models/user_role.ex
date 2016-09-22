defmodule TinyFair.UserRole do
  use TinyFair.Web, :model

  schema "user_roles" do
    field :rolename, :string

    many_to_many :users, TinyFair.User, join_through: "users_roles"
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:rolename])
    |> validate_required([:rolename])
  end
end
