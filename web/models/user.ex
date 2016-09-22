defmodule TinyFair.User do
  use TinyFair.Web, :model

  schema "users" do
    field :username
    field :password, :string, virtual: true
    field :password_hash

    field :email
    field :phone
    field :line_id

    field :status, :string, default: "active"
    field :level, :float, default: 0.0

    many_to_many :roles, TinyFair.UserRole, join_through: "users_roles"

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username])
    |> validate_required([:username])
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :password])
    |> validate_required([:username, :password])
    |> update_change(:username, &String.downcase/1)
    |> validate_length(:username, min: 4, max: 20)
    |> validate_length(:password, min: 6)
    |> validate_format(:username, ~r/^[a-z0-9_\-\.!~\*'\(\)]+$/)
    |> unique_constraint(:username)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true} = changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:password_hash, Comeonin.Bcrypt.hashpwsalt(password))
  end

  defp hash_password(changeset), do: changeset
end
